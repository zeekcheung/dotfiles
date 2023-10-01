local util = require("lazy.core.util")

local M = {}

---@type PluginLspOpts
M.opts = nil

-- Allow plugins to set a custom formatter for a buffer.
-- See the conform extra for an example.
---@type fun(bufnr:number):boolean
M.custom_format = nil

M.is_enabled = function()
  return M.opts.autoformat
end

M.toggle = function()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    M.opts.autoformat = true
  else
    M.opts.autoformat = not M.opts.autoformat
  end
  if M.opts.autoformat then
    util.info("Enabled format on save", { title = "Format" })
  else
    util.warn("Disabled format on save", { title = "Format" })
  end
end

---@param opts? {force?:boolean}
M.format = function(opts)
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false and not (opts and opts.force) then
    return
  end

  if M.custom_format and util.try(function()
    M.custom_format(buf)
  end, { msg = "Custom formatter failed" }) then
    return
  end

  local formatters = M.get_formatters(buf)
  local client_ids = vim.tbl_map(function(client)
    return client.id
  end, formatters.active)

  if #client_ids == 0 then
    return
  end

  if M.opts.format_notify then
    M.notify(formatters)
  end

  vim.lsp.buf.format(vim.tbl_deep_extend("force", {
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(client_ids, client.id)
    end,
  }, require("utils").opts("nvim-lspconfig").format or {}))
end

---@param formatters LazyVimFormatters
M.notify = function(formatters)
  local lines = { "# Active:" }

  for _, client in ipairs(formatters.active) do
    local line = "- **" .. client.name .. "**"
    if client.name == "null-ls" then
      line = line
        .. " ("
        .. table.concat(
          vim.tbl_map(function(f)
            return "`" .. f.name .. "`"
          end, formatters.null_ls),
          ", "
        )
        .. ")"
    end
    table.insert(lines, line)
  end

  if #formatters.available > 0 then
    table.insert(lines, "")
    table.insert(lines, "# Disabled:")
    for _, client in ipairs(formatters.available) do
      table.insert(lines, "- **" .. client.name .. "**")
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
    title = "Formatting",
    on_open = function(win)
      vim.api.nvim_win_set_option(win, "conceallevel", 3)
      vim.api.nvim_win_set_option(win, "spell", false)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, "markdown")
    end,
  })
end

-- Gets all lsp clients that support formatting.
-- When a null-ls formatter is available for the current filetype,
-- only null-ls formatters are returned.
M.get_formatters = function(bufnr)
  local ft = vim.bo[bufnr].filetype
  -- check if we have any null-ls formatters for the current filetype
  local null_ls = package.loaded["null-ls"] and require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") or {}

  ---@class LazyVimFormatters
  local ret = {
    ---@type lsp.Client[]
    active = {},
    ---@type lsp.Client[]
    available = {},
    null_ls = null_ls,
  }

  ---@type lsp.Client[]
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      if (#null_ls > 0 and client.name == "null-ls") or #null_ls == 0 then
        table.insert(ret.active, client)
      else
        table.insert(ret.available, client)
      end
    end
  end

  return ret
end

-- Gets all lsp clients that support formatting
-- and have not disabled it in their client config
---@param client lsp.Client
M.supports_format = function(client)
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

---@param opts PluginLspOpts
M.setup = function(opts)
  M.opts = opts
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LazyVimFormat", {}),
    callback = function()
      if M.opts.autoformat then
        M.format()
      end
    end,
  })
end

return M