local lsp_utils = require("plug_configs.lsp.utils")
local lspCapabilities = lsp_utils.lspCapabilities

vim.lsp.config('lua_ls', {
  capabilities = lspCapabilities,
  filetypes = { "lua" },
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          trim_trailing_whitespace = "true",
          insert_final_newline = "true",
        },
      },
    },
  },
})
