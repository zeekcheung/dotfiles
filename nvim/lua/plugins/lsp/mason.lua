return {
  "williamboman/mason.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "Mason",
  keys = {
    { "<leader>lm", ":Mason<cr>", desc = "Mason", silent = true },
    { "<leader>li", ":LspInfo<cr>", desc = "LSP Info", silent = true },
    { "<leader>lI", ":LspInstal<cr>", desc = "LSP Install", silent = true },
    { "<leader>ll", ":LspLog<cr>", desc = "LSP Log", silent = true },
    { "<leader>lr", ":LspRestart<cr>", desc = "LSP Restart", silent = true },
    { "<leader>ls", ":LspStop<cr>", desc = "LSP Strop", silent = true },
    { "<leader>lu", ":LspUninstall<cr>", desc = "LSP Uninstall", silent = true },
  },
  config = function(_, opts)
    local mason = require("mason")
    local mr = require("mason-registry")
    local ensure_installed = function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end

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

    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}
