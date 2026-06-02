local M = {}

local lsputil = require("lspconfig.util")
local lsp_utils = require("plug_configs.lsp.utils")
local lspCapabilities = lsp_utils.lspCapabilities


vim.lsp.config('pyright', {
  capabilities = lspCapabilities,
  filetypes = { "python" },
  -- root_dir = lsputil.root_pattern(
  --   ".git",
  --   "requirements.txt",
  --   "pyproject.toml",
  --   "Makefile",
  --   "README.md"
  -- ),
  -- settings = {
  --   python = {
  --     analysis = {
  --       autoSearchPaths = true,
  --       diagnosticMode = "openFilesOnly",
  --       useLibraryCodeForTypes = true,
  --       typeCheckingMode = "off", -- или "strict"
  --     },
  --   },
  -- },
})
vim.lsp.enable('pyright') -- прикрепит к уже открытым python-буферам


-- require("lspconfig").pyre.setup({ })

-- NOTE: for codeactions
-- require("lspconfig").ruff_lsp.setup({
--   filetypes = { "python" },
--   settings = {
--     organizeImports = false,
--   },
--   -- disable ruff as hover provider to avoid conflicts with pyright
--   on_attach = function(client)
--     client.server_capabilities.hoverProvider = false
--   end,
-- })

-- NOTE: https://github.com/DetachHead/basedpyright

--[[
require("lspconfig").basedpyright.setup({
  capabilities = lspCapabilities,
  filetypes = { "python" },
  root_dir = lsputil.root_pattern(".git", "requirements.txt", "pyproject.toml", "Makefile", "README.md"),
  settings = {
    -- https://microsoft.github.io/pyright/#/configuration?id=main-configuration-options
    analysis = {
      autoSearchPaths = true,
      diagnosticMode = "workspace",
      useLibraryCodeForTypes = true,
      -- typeCheckingMode = "standard",
      typeCheckingMode = "basic",
    },
    diagnosticSeverityOverrides = {
      reportUnusedCallResult = "information",
      reportUnusedExpression = "information",
      reportUnknownMemberType = "none",
      reportUnknownLambdaType = "none",
      reportUnknownParameterType = "none",
      reportMissingParameterType = "none",
      reportUnknownVariableType = "none",
      reportUnknownArgumentType = "none",
      reportAny = "none",
      reportImplicitStringConcatenation = "none",
    },
  },
})
--]]
return M
