require("lspconfig").sqls.setup({
  cmd = { "sqls", "-config", "~/.config/nvim/sqls.yml" },
  on_attach = function(client, bufnr)
    require("sqls").on_attach(client, bufnr)
  end,
})
