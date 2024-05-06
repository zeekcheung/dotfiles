-- NOTE: Some util functions for lsp
local M = {}

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

-- Setup lsp keymaps for buffer
---@diagnostic disable-next-line: unused-local
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
