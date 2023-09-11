local M = {}

M.format = function()
  require("lazyvim.plugins.lsp.format").format({ force = true })
end

M.source_code_action = function()
  vim.lsp.buf.code_action({
    context = {
      only = {
        "source",
      },
      diagnostics = {},
    },
  })
end

M.rename = function()
  if require("lazyvim.util").has("inc-rename.nvim") then
    return function()
      local inc_rename = require("inc_rename")
      return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
    end
  else
    return vim.lsp.buf.rename
  end
end

return M
