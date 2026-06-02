-- Регистрация конфигурации для sqls через vim.lsp.config
vim.lsp.config('sqls', {
  cmd = { "sqls", "-config", vim.fn.expand("~/.config/nvim/sqls.yml") },
})

-- Включение LSP
vim.lsp.enable('sqls')
