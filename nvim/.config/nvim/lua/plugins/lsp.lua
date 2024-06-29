local Lsp = require 'util.lsp'

return {
  -- Language servers
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'b0o/SchemaStore.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              winblend = vim.g.transparent_background and 0 or 10,
            },
          },
        },
      },
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        cmd = 'LazyDev',
        opts = {},
      },
      {
        'smjonas/inc-rename.nvim',
        cmd = 'IncRename',
        keys = {
          { '<leader>rn', ':IncRename ', desc = 'Rename' },
        },
        config = true,
      },
    },
    config = function()
      -- Setup keymaps and inlay hints on LspAttach
      Lsp.on_attach(function(client, buffer)
        Lsp.setup_keymaps(client, buffer)
        Lsp.setup_inlay_hints(client, buffer)
      end)

      -- Setup diagnostics icons in signcolumn
      Lsp.setup_diagnostics_icons()

      -- Setup diagnostics options
      Lsp.setup_diagnostics_options()

      -- Servers listed below will be automatically installed
      local servers = {
        bashls = { filetypes = { 'sh', 'zsh' } },
        -- powershell_es = {},
        marksman = {},
        taplo = {},
        yamlls = {},
        jsonls = {},
        clangd = {},
        tsserver = {},
        lua_ls = {
          settings = {
            Lua = {
              telemetry = { enable = false },
              diagnostics = { globals = { 'vim' } },
              hint = { enable = true },
              workspace = {
                checkThirdParty = false,
                library = {
                  [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                  [vim.fn.expand '$VIMRUNTIME/lua/vim/lsp'] = true,
                  [vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy'] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
            },
          },
        },
      }

      -- Tools listed below will be automatically installed
      local ensure_installed = vim.list_extend({
        'shfmt',
        'shellcheck',
        'stylua',
        'prettier',
        'eslint_d',
        'markdownlint',
      }, vim.tbl_keys(servers or {}))

      -- Setup mason and mason-lspconfig
      require('mason').setup {
        ui = {
          icons = {
            package_pending = ' ',
            package_installed = '󰄳 ',
            package_uninstalled = '󰚌 ',
          },
        },
      }
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server_opts = servers[server_name] or {}
            Lsp.setup_server { server_name = server_name, server_opts = server_opts }
          end,
        },
      }

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
        fish = { 'fish' },
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
