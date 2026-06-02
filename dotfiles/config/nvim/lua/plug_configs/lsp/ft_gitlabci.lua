local M = {}
M.init = function(capabilities)
  vim.lsp.config("gitlab_ci", {
    capabilities = capabilities,
  })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*ci*.{yml,yaml}",
    callback = function()
      vim.bo.filetype = "yaml.gitlab"
    end,
  })
end

return M
