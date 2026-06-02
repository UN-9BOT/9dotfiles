local M = {
  "TobinPalmer/pastify.nvim",
  cmd = { "Pastify", "PastifyAfter" },
}

local local_path = "/.idea/images/"

local ensure_dir = function()
  vim.fn.mkdir(vim.fn.getcwd() .. local_path, "p")
end

M.config = function()
  require("pastify").setup({
    opts = {
      absolute_path = false,
      local_path = local_path,
      save = "local",
      filename = function()
        return os.date("%Y-%m-%d-%H-%M-%S")
      end,
      default_ft = "markdown",
    },
  })
end

M.keys = {
  {
    ",P",
    mode = { "n" },
    function()
      ensure_dir()
      vim.cmd("Pastify")
    end,
    desc = "Paste image",
  },
}

return M
