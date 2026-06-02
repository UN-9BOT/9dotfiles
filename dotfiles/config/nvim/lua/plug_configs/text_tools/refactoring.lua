local M = {
  "ThePrimeagen/refactoring.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim-treesitter/nvim-treesitter",
  },
}

M.config = function()
  require("refactoring").setup()
  vim.keymap.set({ "n", "x" }, "<leader>rr", function()
    require("refactoring").select_refactor()
  end)
end

return M
