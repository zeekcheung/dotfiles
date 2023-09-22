return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = {
    { "<leader>lm", ":Mason<cr>", desc = "Mason" },
    { "<leader>li", ":LspInfo<cr>", desc = "LSP Info" },
    { "<leader>lI", ":LspInstal<cr>", desc = "LSP Install" },
    { "<leader>ll", ":LspLog<cr>", desc = "LSP Log" },
    { "<leader>lr", ":LspRestart<cr>", desc = "LSP Restart" },
    { "<leader>ls", ":LspStop<cr>", desc = "LSP Strop" },
    { "<leader>lu", ":LspUninstall<cr>", desc = "LSP Uninstall" },
  },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_null_ls = require("mason-null-ls")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    })

    ----------------------- 1. Configure LSP -----------------------
    -- 1) Automatically install language servers via mason-lspconfig
    -- 2) Configure language servers via nvim-lspconfig
    ----------------------------------------------------------------

    mason_lspconfig.setup({
      -- automatically install language servers
      ensure_installed = {
        "bashls", -- bash language server
        "clangd", -- c/cpp language server
        "docker_compose_language_service", -- docker compose language server
        "dockerls", -- docker language server
        "gopls", -- go language server
        "html", -- html language server
        "cssls", -- css language server
        "emmet_ls", -- emmet language server
        "jsonls", -- json language server
        "lua_ls", -- lua language server
        "marksman", -- markdown language server
        "prismals", -- prisma language server
        "pyright", -- python language server
        "ruff_lsp", -- python language server
        "tailwindcss", -- tailwind language server
        "taplo", -- toml language server
        "tsserver", -- javascript/typescript language server
        "denols", -- javascript/typescript language server
        "volar", -- vue language server
        "yamlls", -- yaml language server
      },
      -- automatically configure language servers
      automatic_installation = true,
    })

    ----------------- 2. Configure formatters & linters ----------------
    -- 1) Automatically install formatters and linters via mason-null-ls
    -- 2) Configure formatters and linters via null-ls
    --------------------------------------------------------------------

    mason_null_ls.setup({
      -- automatically install formatters and linters
      ensure_installed = {
        "shellcheck", -- bash linter
        "shfmt", -- bash formatter
        "clang-format", -- c/cpp formatter
        "hadolint", -- docker linter
        "gofumpt", -- go formatter
        "goimports", -- go formatter
        "gomodifytags", -- go code actions
        "impl", -- go code actions
        "stylua", -- lua format
        "prettierd", -- front end formatter
        "eslint_d", -- javascript/typescript linter
        "black", -- python formatter
        "isort", -- python formatter
        "markdownlint", -- markdown linter
      },
      -- automatically configure formatters and linters
      automatic_installation = true,
    })
  end,
}
