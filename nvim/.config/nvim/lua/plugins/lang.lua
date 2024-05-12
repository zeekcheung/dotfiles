local Lsp = require 'util.lsp'
local Ui = require 'util.ui'
local icons = Ui.icons
local border_with_highlight = Ui.border_with_highlight

---@type string
local xdg_config_home = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. '/.config'

---@param package string
local function have_config(package)
  return vim.uv.fs_stat(xdg_config_home .. '/' .. package) ~= nil
end

return {

  -- Installer for language servers, formatters, linters
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      -- Tools listed below will be automatically installed
      ensure_installed = {
        'shfmt',
        'shellcheck',
        'stylua',
        'prettier',
        'eslint_d',
        'markdownlint',
      },
      ui = {
        icons = {
          package_pending = ' ',
          package_installed = '󰄳 ',
          package_uninstalled = '󰚌 ',
        },
      },
    },
    config = function(_, opts)
      -- Setup mason
      require('mason').setup(opts)

      local mason_registry = require 'mason-registry'

      local function install_missing_packages()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mason_registry.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      -- Automatically install missing tools
      if mason_registry.refresh then
        mason_registry.refresh(install_missing_packages)
      else
        install_missing_packages()
      end
    end,
  },

  -- Language servers
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'folke/neodev.nvim', opts = { library = { plugins = false } } },
      {
        'j-hui/fidget.nvim',
        config = function(_, opts)
          if vim.g.transparent_background then
            opts.notification = { window = { winblend = 0 } }
          end
          require('fidget').setup(opts)
        end,
      },
      {
        'ray-x/lsp_signature.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
          bind = true,
          handler_opts = {
            border = border_with_highlight 'SignatureHelpBorder',
          },
          max_width = math.floor(vim.o.columns * 0.75),
          max_height = math.floor(vim.o.lines * 0.75),
          hint_enable = false,
        },
      },
    },
    opts = {
      -- Options for vim.diagnostic.config()
      diagnostics = vim.g.diagnostic_opts,
      inlay_hints = {
        enabled = true,
      },
      capabilities = {},
      -- Servers listed below will be automatically installed via mason
      servers = {
        bashls = { filetypes = { 'sh', 'zsh' } },
        -- powershell_es = {},
        marksman = {},
        taplo = {},
        yamlls = {},
        jsonls = {
          -- Lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        lua_ls = {
          Lua = {
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.api.nvim_get_runtime_file('lua', true),
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        },
        clangd = {
          root_dir = function(fname)
            local lspconfig_util = require 'lspconfig.util'
            local root_pattern = lspconfig_util.root_pattern
            local find_git_ancestor = lspconfig_util.find_git_ancestor
            return root_pattern(
              'Makefile',
              'configure.ac',
              'configure.in',
              'config.h.in',
              'meson.build',
              'meson_options.txt',
              'build.ninja'
            )(fname) or root_pattern('compile_commands.json', 'compile_flags.txt')(fname) or find_git_ancestor(
              fname
            )
          end,
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        tsserver = {
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
      -- Do any additional lsp server setup here
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
        yamlls = function()
          -- Neovim < 0.10 does not have dynamic registration for formatting
          if vim.fn.has 'nvim-0.10' == 0 then
            require('util.lsp').on_lsp_attach(function(client, _)
              if client.name == 'yamlls' then
                client.server_capabilities.documentFormattingProvider = true
              end
            end)
          end
        end,
      },
    },
    config = function(_, opts)
      -- Setup keymaps on LspAttach
      Lsp.on_lsp_attach(function(client, buffer)
        Lsp.setup_lsp_keymaps(client, buffer)
      end)

      -- Setup diagnostics icons in signcolumn
      local diagnostics_icons = icons.diagnostics
      for name, icon in pairs(diagnostics_icons) do
        name = 'DiagnosticSign' .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
      end

      -- Setup other diagnostics options
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(),
        opts.capabilities or {}
      )

      -- Setup language server with `opts.setup`
      local setup_server = function(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        -- Setup hover and signature help
        server_opts.handlers = {
          ['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            { border = border_with_highlight 'HoverBorder', silent = true }
          ),
          ['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = border_with_highlight 'SignatureHelpBorder', focusable = false, silent = true }
          ),
        }

        -- Setup floating preview
        local original_open_floating_preview = vim.lsp.util.open_floating_preview
        ---@diagnostic disable-next-line
        vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
          opts = opts or {}
          -- opts.border = opts.border or 'single'
          opts.max_width = opts.max_width or math.floor(vim.o.columns * 0.75)
          opts.max_height = opts.max_height or math.floor(vim.o.lines * 0.75)
          return original_open_floating_preview(contents, syntax, opts, ...)
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup['*'] then
          if opts.setup['*'](server, server_opts) then
            return
          end
        end
        require('lspconfig')[server].setup(server_opts)
      end

      -- Get all the servers that are available via mason-lspconfig
      local have_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')
      local all_mason_lspconfig_servers = {}
      if have_mason_lspconfig then
        all_mason_lspconfig_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mason_lspconfig_servers, server) then
            setup_server(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      -- Setup mason-lspconfig
      if have_mason_lspconfig then
        mason_lspconfig.setup { ensure_installed = ensure_installed }
        mason_lspconfig.setup_handlers { setup_server }
      end

      -- Avoid denols and tsserver run on the same time
      if Lsp.get_lsp_config 'denols' and Lsp.get_lsp_config 'tsserver' then
        local is_deno = require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc')
        Lsp.disable_lsp('tsserver', is_deno)
        Lsp.disable_lsp('denols', function(root_dir)
          return not is_deno(root_dir)
        end)
      end
    end,
  },

  -- Formatters
  {
    'stevearc/conform.nvim',
    lazy = true,
    cmd = 'ConformInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'mason.nvim' },
    keys = {
      {
        '<leader>fm',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        desc = 'Format buffer',
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- shell
        sh = { 'shfmt' },
        zsh = { 'shfmt' },
        fish = { 'fish_indent' },
        -- webdev
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        less = { 'prettier' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        graphql = { 'prettier' },
        -- misc
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
        ['markdown'] = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
      },
      lsp_ignore_filetypes = { 'ps1' },
    },
    config = function(_, opts)
      opts.format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        local format_args = { timeout_ms = 700, quiet = true, lsp_fallback = true }
        -- Disable lsp format for ignored filetypes
        if vim.tbl_contains(opts.lsp_ignore_filetypes, vim.bo[bufnr].filetype) then
          format_args.lsp_fallback = false
          format_args.formatters = { 'trim_whitespace' }
        end
        return format_args
      end

      require('conform').setup(opts)

      local create_user_command = vim.api.nvim_create_user_command
      -- Create `FormatDisable` command to disable format on save
      create_user_command('FormatDisable', function(args)
        if args.bang then
          -- "FormatDisable!" will disable formatting globally
          vim.g.disable_autoformat = true
        else
          ---@diagnostic disable-next-line
          vim.b.disable_autoformat = true
        end
      end, {
        desc = 'Disable format on save',
        bang = true,
      })
      -- Create `FormatEnable` command to enable format on save
      create_user_command('FormatEnable', function()
        ---@diagnostic disable-next-line
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Enable format on save',
      })
    end,
  },

  -- Linters
  {
    'mfussenegger/nvim-lint',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'mason.nvim' },
    keys = {
      {
        '<leader>cl',
        function()
          require('lint').try_lint()
        end,
        desc = 'Lint buffer',
      },
    },
    opts = {
      linters_by_ft = {
        -- shell
        sh = { 'shellcheck' },
        -- zsh = { 'shellcheck' },
        -- webdev
        javascript = { 'eslint_d' },
        jaavascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        -- misc
        markdown = { 'markdownlint' },
      },
    },
    config = function(_, opts)
      local lint = require 'lint'

      lint.linters_by_ft = opts.linters_by_ft

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      -- Auto lint
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      -- Custom command
      vim.api.nvim_create_user_command('LintInfo', function()
        vim.notify(vim.inspect(lint.linters_by_ft), vim.log.levels.INFO, { title = 'Lint Info' })
      end, {})
    end,
  },

  -- Syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require('lazy.core.loader').add_to_rtp(plugin)
      require 'nvim-treesitter.query_predicates'
    end,
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        lazy = true,
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require 'nvim-treesitter.textobjects.move' ---@type table<string,fun(...)>
          local configs = require 'nvim-treesitter.configs'
          for name, fn in pairs(move) do
            if name:find 'goto' == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find '[%]%[][cC]' then
                      vim.cmd('normal! ' .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'bash',
        -- json
        'json',
        'json5',
        'jsonc',
        -- markdown
        'markdown',
        'markdown_inline',
        -- vim
        'vim',
        'vimdoc',
        -- misc
        'diff',
        'regex',
        'query',
        'toml',
        'xml',
        'yaml',
        -- lua
        'lua',
        'luadoc',
        'luap',
        -- c/cpp
        'c',
        'cpp',
        -- webdev
        -- 'html',
        -- 'css',
        -- 'javascript',
        -- 'jsdoc',
        -- 'typescript',
        -- 'tsx',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
        },
      },
    },
    config = function(_, opts)
      ---@param parser string
      local function add_parser(parser)
        if type(opts.ensure_installed) == 'table' then
          table.insert(opts.ensure_installed, parser)
        end
      end

      -- Define some filetypes
      vim.filetype.add {
        extension = {
          rasi = 'rasi',
          rofi = 'rasi',
          wofi = 'rasi',
        },
        filename = {
          ['.env'] = 'dotenv',
          ['vifmrc'] = 'vim',
        },
        pattern = {
          ['.*/waybar/config'] = 'jsonc',
          ['.*/mako/config'] = 'dosini',
          ['.*/kitty/.+%.conf'] = 'kitty',
          ['.*/hypr/.+%.conf'] = 'hyprlang',
          ['%.env%.[%w_.-]+'] = 'dotenv',
        },
      }

      -- Add parsers
      add_parser 'git_config'
      if have_config 'hypr' then
        add_parser 'hypr'
      end
      if have_config 'fish' then
        add_parser 'fish'
      end
      if have_config 'rofi' or have_config 'wofi' then
        add_parser 'rasi'
      end

      if type(opts.ensure_installed) == 'table' then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end

      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- Show context of the current function
  {
    'nvim-treesitter/nvim-treesitter-context',
    cond = vim.g.sticky_scroll,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = { mode = 'cursor', max_lines = 3 },
  },

  -- Automatically add closing tags for HTML and JSX
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- Schema support
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- last release is way too old
  },
}
