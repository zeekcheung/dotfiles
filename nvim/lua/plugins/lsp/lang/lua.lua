local utils = require("utils")

return {
  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "lua", "luap" })
      end
    end,
  },
  -- language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- install and config lua_ls
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                ignoreDir = {
                  ".vscode",
                  ".git",
                },
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
              completion = {
                callSnippet = "Replace",
              },
              hint = {
                enable = true,
              },
              diagnostics = {
                enable = true,
                globals = {
                  "vim",
                },
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
      },
    },
  },
  -- formatter & linter & code actions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "stylua" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    -- optional = true,
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local nls = require("null-ls")
        vim.list_extend(opts.sources, {
          nls.builtins.formatting.stylua,
        })
      end
    end,
  },
}
