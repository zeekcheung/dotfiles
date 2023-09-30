local M = {}

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
M.get = function()
  local format = function()
    require("utils.lsp.format").format({ force = true })
  end
  if not M._keys then
  ---@class PluginLspKeys
    -- stylua: ignore
    M._keys =  {
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
      { "gt", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto Type Definition" },
      { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
      { "]d", M.goto_diagnostic(true), desc = "Next Diagnostic" },
      { "[d", M.goto_diagnostic(false), desc = "Prev Diagnostic" },
      { "]e", M.goto_diagnostic(true, "ERROR"), desc = "Next Error" },
      { "[e", M.goto_diagnostic(false, "ERROR"), desc = "Prev Error" },
      { "]w", M.goto_diagnostic(true, "WARN"), desc = "Next Warning" },
      { "[w", M.goto_diagnostic(false, "WARN"), desc = "Prev Warning" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
      { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { "<leader>cf", format, desc = "Format Document", has = "formatting" },
      { "<leader>cf", format, desc = "Format Range", mode = "v", has = "rangeFormatting" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "Source Action",
        has = "codeAction",
      }
    }
  end
  return M._keys
end

---@param method string
M.has = function(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = vim.lsp.get_active_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

M.resolve = function(buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  local function add(keymap)
    local keys = Keys.parse(keymap)
    if keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end
  for _, keymap in ipairs(M.get()) do
    add(keymap)
  end

  local opts = require("utils").opts("nvim-lspconfig")
  local clients = vim.lsp.get_active_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    for _, keymap in ipairs(maps) do
      add(keymap)
    end
  end
  return keymaps
end

M.on_attach = function(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end
end

M.goto_diagnostic = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
