return {
  "luukvbaal/statuscol.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" }, -- fold column
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" }, -- number column
        { text = { "%s" }, click = "v:lua.ScSa" }, -- sign column
      },
    })

    -- disable status column for neo-tree
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      callback = function()
        if vim.bo.filetype == "neo-tree" then
          vim.opt_local.statuscolumn = ""
        end
      end,
    })
  end,
}
