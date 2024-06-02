local icons = require 'util.icons'
local border_with_highlight = require('util.highlight').border_with_highlight

-- Some util functions for lsp
local M = {}

-- Call callback(client, buffer) when LspAttach
---@param callback fun(client, buffer)
function M.on_attach(callback)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      callback(client, buffer)
    end,
  })
end

-- Setup keymaps for buffer
---@diagnostic disable-next-line: unused-local
function M.setup_keymaps(client, buffer)
  -- Setup keymaps
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = buffer, desc = desc })
  end

  map('<leader>rn', vim.lsp.buf.rename, 'Rename')
  map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
  map('<leader>d', vim.diagnostic.open_float, 'Line Diagnostics')

  map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
  map('gr', require('telescope.builtin').lsp_references, 'Goto References')
  map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
  map('gt', require('telescope.builtin').lsp_type_definitions, 'Goto Type Definition')
  map('<leader>fs', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

  -- See `:help K` for why this keymap
  map('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- Lesser used LSP functionality
  map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
  map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
  map('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
  map('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, 'Workspace List Folders')
end

-- Toggle inlay hint
function M.toggle_inlay_hints(filter)
  if vim.lsp.inlay_hint ~= nil then
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter))
  end
end

-- Setup inlay hint for buffer
---@diagnostic disable-next-line: unused-local
function M.setup_inlay_hints(client, buffer)
  if client.supports_method 'textDocument/inlayHint' then
    M.toggle_inlay_hints()
    vim.keymap.set('n', '<leader>uh', M.toggle_inlay_hints, { desc = 'Toggle inlay hints' })
  end
end

-- Setup diagnostics icons in signcolumn
function M.setup_diagnostics_icons()
  local diagnostics_icons = icons.diagnostics
  for name, icon in pairs(diagnostics_icons) do
    name = 'DiagnosticSign' .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
  end
end

-- Setup diagnostics options
function M.setup_diagnostics_options()
  vim.diagnostic.config {
    signs = false,
    update_in_insert = false,
    float = { border = 'rounded', focusable = true },
  }
end

-- Generate hover and signatureHelp handlers for language servers
function M.hover_signature_handlers()
  return {
    ['textDocument/hover'] = vim.lsp.with(
      vim.lsp.handlers.hover,
      { border = border_with_highlight 'HoverBorder', silent = true }
    ),
    ['textDocument/signatureHelp'] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      { border = border_with_highlight 'SignatureHelpBorder', focusable = false, silent = true }
    ),
  }
end

-- Modify floating preview
function M.modify_floating_preview()
  local original_open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line
  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
    -- opts.border = opts.border or 'single'
    opts.max_width = opts.max_width or math.floor(vim.o.columns * 0.75)
    opts.max_height = opts.max_height or math.floor(vim.o.lines * 0.75)
    return original_open_floating_preview(contents, syntax, opts, ...)
  end
end

-- Setup language server with options or setup function
--- @param opts {server_name: string, server_opts?: table, capabilities?: table }
function M.setup_server(opts)
  local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities(),
    opts.capabilities or {}
  )
  local hover_signature_handlers = M.hover_signature_handlers()

  -- Add capabilities and handlers to server options
  local server_opts = vim.tbl_deep_extend('force', {
    capabilities = vim.deepcopy(capabilities),
    handlers = vim.deepcopy(hover_signature_handlers),
  }, opts.server_opts or {})

  M.modify_floating_preview()

  require('lspconfig')[opts.server_name].setup(server_opts)
end

-- Get configs of language server
function M.get_lsp_config(server)
  local configs = require 'lspconfig.configs'
  return rawget(configs, server)
end

-- Disable language server
---@param server string
---@param cond fun( root_dir, config): boolean
function M.disable_lsp(server, cond)
  local util = require 'lspconfig.util'
  local def = M.get_lsp_config(server)

  def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config, function(config, root_dir)
    if cond(root_dir, config) then
      config.enabled = false
    end
  end)
end

return M
