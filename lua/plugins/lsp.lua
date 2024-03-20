local Lsp = require 'util.lsp'
local Ui = require 'util.ui'
local icons = Ui.icons

return {

  -- Installer for language servers, formatters, linters
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      -- Tools listed below will be automatically installed
      ensure_installed = {},
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

      -- Automatically install missing tools
      local ensure_installed = function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mason_registry.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      if mason_registry.refresh then
        mason_registry.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Language servers
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      {
        'j-hui/fidget.nvim',
        config = function(_, opts)
          if vim.g.transparent_background then
            opts.notification = { window = { winblend = 0 } }
          end
          require('fidget').setup(opts)
        end,
      },
    },
    opts = {
      -- Options for vim.diagnostic.config()
      diagnostics = {
        -- signs = false,
        underline = true,
        update_in_insert = false,
        -- virtual_text = {
        --   spacing = 4,
        --   source = 'if_many',
        --   prefix = '●',
        -- },
        severity_sort = true,
        float = {
          header = false,
          border = 'rounded',
          focusable = true,
        },
      },
      inlay_hints = {
        enabled = true,
      },
      -- Automatically format on save
      autoformat = true,
      capabilities = {},
      -- Options for vim.lsp.buf.format
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- Servers listed below will be automatically installed through mason
      servers = {},
      -- Do any additional lsp server setup here
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
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
      local capabilities =
        vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities(), opts.capabilities or {})

      -- Setup language server with `opts.setup`
      local setup_server = function(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        -- Setup borders for hover and signature help
        if vim.g.hover_custom_border then
          server_opts.handlers = {
            ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = vim.g.border_style }),
            ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = vim.g.border_style }),
          }
        end

        -- Setup floating preview
        local open_floating_preview = vim.lsp.util.open_floating_preview
        vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
          opts = opts or {}
          -- opts.border = opts.border or 'single'
          opts.max_width = opts.max_width or 80
          opts.max_height = opts.max_height or 40
          return open_floating_preview(contents, syntax, opts, ...)
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
      formatters_by_ft = {},
      lsp_ignore_filetypes = {},
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
          vim.b.disable_autoformat = true
        end
      end, {
        desc = 'Disable format on save',
        bang = true,
      })
      -- Create `FormatEnable` command to enable format on save
      create_user_command('FormatEnable', function()
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
      linters_by_ft = {},
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
        vim.notify(vim.inspect(lint.linters_by_ft), 'info', { title = 'Lint Info' })
      end, {})
    end,
  },
}
