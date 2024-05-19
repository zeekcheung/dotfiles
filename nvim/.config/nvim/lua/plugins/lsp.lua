local Lsp = require 'util.lsp'

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
      'b0o/SchemaStore.nvim',
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
            border = require('util.ui').border_with_highlight 'SignatureHelpBorder',
          },
          max_width = math.floor(vim.o.columns * 0.75),
          max_height = math.floor(vim.o.lines * 0.75),
          hint_enable = false,
        },
      },
    },
    opts = {
      -- Only neovim >= 0.10.0 support inlay hints
      inlay_hints = { enabled = true },
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
          settings = {
            Lua = {
              telemetry = { enable = false },
              diagnostics = {
                globals = { 'vim' },
              },
              hint = {
                enable = true,
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
    },
    config = function(_, opts)
      -- Setup keymaps and inlay hints on LspAttach
      Lsp.on_attach(function(client, buffer)
        Lsp.setup_keymaps(client, buffer)
        if opts.inlay_hints.enabled then
          Lsp.setup_inlay_hints(client, buffer)
        end
      end)

      -- Setup diagnostics icons in signcolumn
      Lsp.setup_diagnostics_icons()

      -- Setup diagnostics options
      Lsp.setup_diagnostics_options()

      local servers = opts.servers
      local function setup_server(server)
        Lsp.setup_server { name = server, capabilities = opts.capabilities, options = servers[server] }
      end

      local have_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')

      -- Get all the servers that are available via mason-lspconfig
      local function get_mason_lspconfig_servers()
        local all_mason_lspconfig_servers = {}
        if have_mason_lspconfig then
          all_mason_lspconfig_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
        end
        return all_mason_lspconfig_servers
      end

      -- Generate ensure_installed for mason-lspconfig
      local function generate_ensure_installed(mason_lspconfig_servers)
        local ensure_installed = {}
        for server, server_opts in pairs(servers) do
          if server_opts then
            server_opts = server_opts == true and {} or server_opts
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(mason_lspconfig_servers, server) then
              setup_server(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end

        return ensure_installed
      end

      -- Setup mason-lspconfig
      if have_mason_lspconfig then
        mason_lspconfig.setup {
          ensure_installed = generate_ensure_installed(get_mason_lspconfig_servers()),
        }
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
}
