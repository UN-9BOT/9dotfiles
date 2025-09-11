local M = {
  "OXY2DEV/markview.nvim" ,
  lazy=false,
  dependencies = {
    { "HakonHarnes/img-clip.nvim", event = "BufEnter" }, -- NOTE: :PasteImage
  },

}
M.ft = { "markdown" }

return M
