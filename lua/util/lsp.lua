-- NOTE: Some util functions for lsp
local M = {}

-- lsp root patterns
M.root_patterns = { '.git', 'lua' }

-- Call on_acttach(client, buffer) when LspAttach
---@param on_attach fun(client, buffer)
function M.on_lsp_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

-- Format current buffer
---@param opts? {force?:boolean}
function M.format(opts)
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false and not (opts and opts.force) then
    return
  end
  local ft = vim.bo[buf].filetype
  local have_nls = #require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') > 0

  vim.lsp.buf.format(vim.tbl_deep_extend('force', {
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == 'null-ls'
      end
      return client.name ~= 'null-ls'
    end,
  }, M.opts('nvim-lspconfig').format or {}))
end

-- Whether enable auto format
M.autoformat = true
-- Toggle auto format
function M.toggle_autoformat()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    M.autoformat = true
  else
    M.autoformat = not M.autoformat
  end
  if M.autoformat then
    vim.notify 'Enabled format on save'
  else
    vim.notify 'Disabled format on save'
  end
end

-- Setup auto format for buffer
function M.setup_autoformat(client, buffer)
  -- don't format if client disabled it
  if client.config and client.config.capabilities and client.config.capabilities.documentFormattingProvider == false then
    return
  end

  -- Config auto format
  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. buffer, {}),
      buffer = buffer,
      callback = function()
        if M.autoformat then
          M.format()
        end
      end,
    })
  end
end

-- Setup lsp keymaps for buffer
function M.setup_lsp_keymaps(client, buffer)
  -- Setup keymaps
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = buffer, desc = desc })
  end

  map('<leader>rn', vim.lsp.buf.rename, 'Rename')
  map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

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
