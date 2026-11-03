local M = {
  "rmagatti/gx-extended.nvim",
  keys = { "gx" },
  config = function()
    local lazy_util = require("lazy.util")

    require("gx-extended").setup({
      -- Use lazy.nvim's open function instead of netrw#BrowseX
      open_fn = lazy_util.open,
    })
  end,
}

return M
