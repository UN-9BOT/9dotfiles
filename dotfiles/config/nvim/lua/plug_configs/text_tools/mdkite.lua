local M = {
  "selimacerbas/mdkite.nvim",
  dependencies = { "selimacerbas/live-server.nvim" },
  config = function()
    require("mdkite").setup({
      auto_refresh = true,
      open_browser = true,
      auto_refresh_events = {
        "BufEnter",
        "BufWinEnter",
        "InsertLeave",
        "TextChanged",
        "TextChangedI",
        "BufWritePost",
      },
      debounce_ms = 200,
    })
  end,
}

return M
