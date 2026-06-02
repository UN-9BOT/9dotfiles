local M = {
  "nvim-zh/colorful-winsep.nvim",
  event = { "WinLeave" },
  branch = "main",
  config = function()
    require("colorful-winsep").setup({
      -- choose between "single", "rounded", "bold" and "double".
      -- Or pass a table like this: { "─", "│", "┌", "┐", "└", "┘" },
      border = "bold",
      excluded_ft = { "packer", "TelescopePrompt", "mason" },
      highlight = nil,
      animate = {
        enabled = false,
      },
      indicator_for_2wins = {
        -- only work when the total of windows is two
        position = "both", -- false to disable or choose between "center", "start", "end" and "both"
        symbols = {
          -- the meaning of left, down ,up, right is the position of separator
          start_left = "󱞬",
          end_left = "󱞪",
          start_down = "󱞾",
          end_down = "󱟀",
          start_up = "󱞢",
          end_up = "󱞤",
          start_right = "󱞨",
          end_right = "󱞦",
        },
      },
    })
  end,
}
return M
