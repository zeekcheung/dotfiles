local opt = vim.opt_local

opt.commentstring = '# %s'

-- Remove extra new lines at the end of formatted PowerShell files
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('powershell_newline', { clear = true }),
  pattern = '*.ps1',
  callback = function()
    local winview = vim.fn.winsaveview()
    vim.cmd [[%s/\n\%$//ge]]
    vim.fn.winrestview(winview)
  end,
})
