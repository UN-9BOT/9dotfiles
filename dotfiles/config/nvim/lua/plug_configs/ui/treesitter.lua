local M = {
  "neovim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "neovim-treesitter/treesitter-parser-registry",
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      config = function()
        require("nvim-treesitter-textobjects").setup({
          select = {
            lookahead = true,
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
            },
            include_surrounding_whitespace = true,
          },
        })

        local select = function(lhs, query, group, desc)
          vim.keymap.set({ "x", "o" }, lhs, function()
            require("nvim-treesitter-textobjects.select").select_textobject(query, group or "textobjects")
          end, { desc = desc })
        end

        select("af", "@function.outer", nil, "Select outer function")
        select("if", "@function.inner", nil, "Select inner function")
        select("al", "@loop.outer", nil, "Select outer loop")
        select("il", "@loop.inner", nil, "Select inner loop")
        select("ac", "@comment.outer", nil, "Select outer comment")
        select("ic", "@comment.inner", nil, "Select inner comment")
        select("as", "@local.scope", "locals", "Select language scope")
      end,
    },
    -- { "andersevenrud/nvim_context_vt" },
    { "dariuscorvus/tree-sitter-language-injection.nvim", opts = {}, event = { "BufReadPre" } }, -- for injections
    -- { "TheNoeTrevino/roids.nvim" }, -- other injections  # language: html
    -- {
    --   "nvim-treesitter/nvim-treesitter-context",
    --   config = function()
    --     require("treesitter-context").setup({
    --       enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    --       max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
    --       min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    --       line_numbers = true,
    --       multiline_threshold = 1, -- Maximum number of lines to show for a single context
    --       trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    --       mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
    --       -- Separator between context and content. Should be a single character string, like '-'.
    --       -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    --       separator = nil,
    --       zindex = 20, -- The Z-index of the context window
    --       on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    --     })
    --   end,
    -- },
  },
}

M.config = function()
  -- vim.opt.foldmethod = "expr"
  -- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.opt.foldlevelstart = 99 -- load buffers with folds open
  local treesitter = require("nvim-treesitter")
  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  local ensure_installed = {
    "bash",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "vim",
    "vimdoc",
  }
  local installed = {}
  for _, lang in ipairs(treesitter.get_installed("parsers")) do
    installed[lang] = true
  end
  local missing = {}
  for _, lang in ipairs(ensure_installed) do
    if not installed[lang] then
      table.insert(missing, lang)
    end
  end
  if #missing > 0 then
    treesitter.install(missing):wait(300000)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true }),
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  vim.keymap.set("n", "<M-t>", function()
    if vim.b.ts_highlight then
      vim.treesitter.stop()
    else
      vim.treesitter.start()
    end
  end, { desc = "Toggle Treesitter Highlight" })
end

return M
