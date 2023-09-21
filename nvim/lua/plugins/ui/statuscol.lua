return {
  "luukvbaal/statuscol.nvim",
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
        { text = { "%s" }, click = "v:lua.ScSa" },
      },
    })
  end,
}
