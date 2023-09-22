return {
  "luukvbaal/statuscol.nvim",
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
  end,
}
