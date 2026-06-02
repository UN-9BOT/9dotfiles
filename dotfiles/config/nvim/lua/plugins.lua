local lazy = require("lazy_init").lazy
local u = require("utils")

lazy.setup({
  -- -----------------------
  -- NOTE: WITHOUT CONFIG
  -- -----------------------
  --
  { "nvim-lua/plenary.nvim" }, -- common utilities
  { "kkharji/sqlite.lua" }, -- sqlite for other plug_configs
  { "farmergreg/vim-lastplace" }, -- last position in files
  { "wellle/targets.vim" }, -- next for textobjects in( an( {["'  or previous 2ab
  { "tpope/vim-fugitive" }, -- :G
  { "RRethy/vim-tranquille" }, -- search and highlight without moving g/
  { "raimon49/requirements.txt.vim" }, -- for syntax highlight for requirements.txt
  { "RRethy/nvim-align", cmd = { "Align" } }, -- выравнивание
  { "b0o/incline.nvim", config = u.r("incline") }, -- float name for tab
  { "numToStr/Comment.nvim", config = u.r("Comment") }, -- commentary for if (Loop)
  { "nacro90/numb.nvim", config = u.r("numb") }, -- live preview for :{number_line}
  { "andrewferrier/debugprint.nvim", config = u.r("debugprint") }, -- debug print g?v
  { "m-demare/hlargs.nvim", config = u.r("hlargs") }, -- ts based for hl args
  { "j-hui/fidget.nvim", opts = {} }, -- ui for lsp-progress
  { "kazhala/close-buffers.nvim" }, -- autoclose hidden buffers (optimization)
  { "meznaric/key-analyzer.nvim", opts = {} }, -- KeyAnalyzer
  { "tpope/vim-surround", dependencies = { "tpope/vim-repeat" } }, -- surround ("' [ { }]')  	-: ysiw' | cs'" | ds"
  { "NStefan002/visual-surround.nvim", config = u.r("visual-surround") }, -- surround visual mode ( [{( )
  { "isak102/ghostty.nvim", config = u.r("ghostty") }, -- ghostty config linting
  { "nullromo/go-up.nvim", config = u.r("go-up") }, -- extra top lines
  { "yochem/jq-playground.nvim", opts = { cmd = { "gojq" } } }, -- jq playground
  { "nvimdev/indentmini.nvim", config = u.r("indentmini") }, -- pipe view for indent

  -- -----------------------
  -- NOTE: WITH CONFIG
  -- -----------------------
  --
  u.safe_require("plug_configs.snacks"), -- all_in_one
  u.safe_require("plug_configs.navigate.langmapper"), -- langmapper
  u.safe_require("plug_configs.ui.my_theme"), -- themes
  u.safe_require("plug_configs.ui.edgy"), -- ui
  u.safe_require("plug_configs.ui.nvim_web_devicons"), -- for other _configsgins, extend with icons
  u.safe_require("plug_configs.ui.bufferline"), -- buffers / tabs on top
  u.safe_require("plug_configs.ui.bmessages"), -- wrapper for :messages
  u.safe_require("plug_configs.ui.lualine"), -- line on bottom
  u.safe_require("plug_configs.ui.treesitter"), -- highlight syntax
  u.safe_require("plug_configs.ui.nvim-window-picker"), -- window picker for file_browser
  -- u.safe_require("plug_configs.ui.markdown-preview"), -- markdown preview :MarkdownPreview
  -- u.safe_require("plug_configs.ui.rainbow_delimiters"), -- rainbow brackets and operators
  u.safe_require("plug_configs.ui.todo_comments"), -- TODO: WARNING: FIX: XXX: BUG: NOTE:
  u.safe_require("plug_configs.ui.whichkey"), -- help for keymaps
  u.safe_require("plug_configs.ui.colorful_winsep"), -- colorful winseparation
  u.safe_require("plug_configs.ui.nvim-highlight-colors"), -- colors for hex and rgb notation
  -- u.safe_require("plug_configs.ui.image"), -- render images in buffer
  u.safe_require("plug_configs.text_tools.neogen"), -- DOCSTRING (doxygen)
  u.safe_require("plug_configs.text_tools.conform"), -- Autoformat
  u.safe_require("plug_configs.text_tools.autopair"), -- auto pair brackets and quotes (A-e for offset)
  u.safe_require("plug_configs.text_tools.pastify"), -- paste image from clipboard
  u.safe_require("plug_configs.text_tools.pantran"), -- translate : leader tr
  u.safe_require("plug_configs.text_tools.refactoring"), -- refactoring for languages
  u.safe_require("plug_configs.text_tools.nvim-macro"), -- macro recorder
  u.safe_require("plug_configs.text_tools.attempt_buffers"), -- temp buffer
  u.safe_require("plug_configs.text_tools.switch"), -- toggle true / false
  u.safe_require("plug_configs.text_tools.swap_case"), -- swap case
  u.safe_require("plug_configs.text_tools.iswap"), -- swap nodes on treesitter
  u.safe_require("plug_configs.text_tools.nvim-rip-substitute"), -- rip substitute
  u.safe_require("plug_configs.git.gitsigns"), -- right sign inline
  u.safe_require("plug_configs.git.diffview"), -- Leader+D -- diffview in n/x
  u.safe_require("plug_configs.git.gitblame"), -- git blame
  u.safe_require("plug_configs.git.gitdev"), -- open repos in temp dir
  u.safe_require("plug_configs.linting.nvim_lint"), -- Lint
  u.safe_require("plug_configs.dap.dap"), -- debugger protocol
  u.safe_require("plug_configs.dap.dap_virtual_text"), -- virtual text dap (eol)
  u.safe_require("plug_configs.dap.dap_python"), -- config dap python
  u.safe_require("plug_configs.dap.envfiles"), -- auto load .env files [[:Dotenv : load .env]]
  u.safe_require("plug_configs.dap.neotest"), -- tests ui
  u.safe_require("plug_configs.dap.conjure"), -- runner code
  u.safe_require("plug_configs.search.grug"), -- search and replace
  u.safe_require("plug_configs.search.yankbank"), -- yank register ,r
  u.safe_require("plug_configs.search.telescope"), -- telescope
  u.safe_require("plug_configs.search.trouble"), -- quickfix, bug-list and other (telescope ctrl+q :  (x del))
  u.safe_require("plug_configs.search.websearch"), -- ,w search in browser
  u.safe_require("plug_configs.navigate.hlslens"), -- for navigate in search mode
  u.safe_require("plug_configs.navigate.vim_smooth_scroll"), -- scrolling
  u.safe_require("plug_configs.navigate.easymotion"), -- fast motion
  u.safe_require("plug_configs.navigate.spider"), -- moving for only word (w e b)
  u.safe_require("plug_configs.navigate.smart-splits"), -- navigate and resize tmux [[ ctrl : navigate, alt : resize ]]
  u.safe_require("plug_configs.navigate.yazi"), -- yazi fm
  u.safe_require("plug_configs.navigate.oil"), -- oil
  u.safe_require("plug_configs.navigate.arrow"), -- marks v2
  u.safe_require("plug_configs.navigate.ya_bookmarks"), -- bookmarks
  u.safe_require("plug_configs.navigate.vim_auto_save"), -- auto-save files
  u.safe_require("plug_configs.navigate.sessions"), -- session
  u.safe_require("plug_configs.lsp.mason"), -- installer for features
  u.safe_require("plug_configs.lsp.none_ls"), -- custom code actions
  u.safe_require("plug_configs.lsp.nvim_lspconfig"), -- lsp config
  u.safe_require("plug_configs.lsp.navbuddy"), -- lsp navigation
  u.safe_require("plug_configs.lsp.live_rename"), -- live rename
  u.safe_require("plug_configs.ai.supermaven"), -- supermaven AI completion
  u.safe_require("plug_configs.completition.nvim_cmp"), -- completition
  u.safe_require("plug_configs.text_tools.multicursor"), -- multicursor

  -- ----------------------------
  -- NOTE: IN_PROGRESS
  -- ----------------------------
  --

  {
    "stevearc/overseer.nvim",
    opts = {},
    keys = {
      {
        "<leader>o",
        mode = { "n" },
        function()
          vim.cmd("OverseerRun")
        end,
        desc = "overseer",
      },
    },
    config = function()
      local overseer = require("overseer")
      overseer.setup()

      overseer.register_template({
        name = "pre-commit run -a",
        builder = function()
          return {
            cmd = { "pre-commit" },
            args = { "run", "-a" },
            components = {
              { "on_output_quickfix", open = true },
              "default",
            },
          }
        end,
        priority = 2,
      })
    end,
  },
  {
    "UN-9BOT/sql-ghosty.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      show_hints_by_default = true,
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      -- global handler
      -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
      -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.
      vim.o.foldcolumn = "0" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
      require("ufo").setup({
        fold_virt_text_handler = handler,
      })
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

      -- buffer scope handler
      -- will override global handler if it is existed
      -- local bufnr = vim.api.nvim_get_current_buf()
      -- require('ufo').setFoldVirtTextHandler(bufnr, handler)
      -- require("ufo").setup({})
    end,
  },
  -- {
  --   "UtkarshKunwar/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   ft = { "markdown" },
  --   build = function()
  --     vim.fn["mkdp#util#install"]()
  --   end,
  -- },
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
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
  },
  {
    "rmagatti/gx-extended.nvim",
    keys = { "gx" },
    config = function()
      local lazy_util = require("lazy.util")

      require("gx-extended").setup({
        -- Use lazy.nvim's open function instead of netrw#BrowseX
        open_fn = lazy_util.open,
      })
    end,
  },
  {
    "sourcegraph/amp.nvim",
    branch = "main",
    lazy = false,
    opts = { auto_start = true, log_level = "info" },
  },
  {
    "folke/sidekick.nvim",
    keys = {
      -- {
      --   "<tab>",
      --   function()
      --     -- if there is a next edit, jump to it, otherwise apply it if any
      --     if not require("sidekick").nes_jump_or_apply() then
      --       return "<Tab>" -- fallback to normal tab
      --     end
      --   end,
      --   expr = true,
      --   desc = "Goto/Apply Next Edit Suggestion",
      -- },
      -- {
      --   "<c-.>",
      --   function()
      --     require("sidekick.cli").toggle()
      --   end,
      --   desc = "Sidekick Toggle",
      --   mode = { "n", "t", "i", "x" },
      -- },
      {
        "<leader>xa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>xs",
        function()
          require("sidekick.cli").select()
        end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>xd",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>xt",
        function()
          require("sidekick.cli").send({ msg = " {this} " })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>xf",
        function()
          require("sidekick.cli").send({ msg = " {file} " })
        end,
        desc = "Send File",
      },
      {
        "<leader>xv",
        function()
          require("sidekick.cli").send({ msg = " {selection}\n{line} " })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>xl",
        function()
          require("sidekick.cli").send({ msg = " {line} " })
        end,
        mode = { "x", "n" },
        desc = "Send Line",
      },
      {
        "<leader>xp",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      -- {
      --   "<leader>xc",
      --   function()
      --     require("sidekick.cli").toggle({ name = "codex", focus = true })
      --   end,
      --   desc = "Sidekick Toggle Claude",
      -- },
    },
    config = function(_, opts)
      require("sidekick").setup({
        jump = {
          jumplist = true, -- add an entry to the jumplist
        },
        signs = {
          enabled = true, -- enable signs by default
          icon = " ",
        },
        nes = {
          ---@type boolean|fun(buf:integer):boolean?
          enabled = function(buf)
            return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
          end,
          debounce = 100,
          trigger = {
            -- events that trigger sidekick next edit suggestions
            events = { "ModeChanged i:n", "TextChanged", "User SidekickNesDone" },
          },
          clear = {
            -- events that clear the current next edit suggestion
            events = { "TextChangedI", "InsertEnter" },
            esc = true, -- clear next edit suggestions when pressing <Esc>
          },
          ---@class sidekick.diff.Opts
          ---@field inline? "words"|"chars"|false Enable inline diffs
          diff = {
            inline = "words",
          },
        },
        -- Work with AI cli tools directly from within Neovim
        cli = {
          watch = true, -- notify Neovim of file changes done by AI CLI tools
          ---@class sidekick.win.Opts
          win = {
            --- This is run when a new terminal is created, before starting it.
            --- Here you can change window options `terminal.opts`.
            ---@param terminal sidekick.cli.Terminal
            config = function(terminal) end,
            wo = {}, ---@type vim.wo
            bo = {}, ---@type vim.bo
            layout = "right", ---@type "float"|"left"|"bottom"|"top"|"right"
            --- Options used when layout is "float"
            ---@type vim.api.keyset.win_config
            float = {
              width = 0.9,
              height = 0.9,
            },
            -- Options used when layout is "left"|"bottom"|"top"|"right"
            ---@type vim.api.keyset.win_config
            split = {
              width = 10, -- set to 0 for default split width
              height = 10, -- set to 0 for default split height
            },
            --- CLI Tool Keymaps (default mode is `t`)
            ---@type table<string, sidekick.cli.Keymap|false>
            keys = {
              buffers = { "<c-b>", "buffers", mode = "nt", desc = "open buffer picker" },
              files = { "<c-f>", "files", mode = "nt", desc = "open file picker" },
              hide_n = { "q", "hide", mode = "n", desc = "hide the terminal window" },
              hide_ctrl_q = { "<c-q>", "hide", mode = "n", desc = "hide the terminal window" },
              hide_ctrl_dot = { "<c-.>", "hide", mode = "nt", desc = "hide the terminal window" },
              hide_ctrl_z = { "<c-z>", "hide", mode = "nt", desc = "hide the terminal window" },
              prompt = { "<c-p>", "prompt", mode = "t", desc = "insert prompt or context" },
              stopinsert = { "<c-q>", "stopinsert", mode = "t", desc = "enter normal mode" },
              -- Navigate windows in terminal mode. Only active when:
              -- * layout is not "float"
              -- * there is another window in the direction
              -- With the default layout of "right", only `<c-h>` will be mapped
              nav_left = { "<c-h>", "nav_left", expr = true, desc = "navigate to the left window" },
              nav_down = { "<c-j>", "nav_down", expr = true, desc = "navigate to the below window" },
              nav_up = { "<c-k>", "nav_up", expr = true, desc = "navigate to the above window" },
              nav_right = { "<c-l>", "nav_right", expr = true, desc = "navigate to the right window" },
            },
            ---@type fun(dir:"h"|"j"|"k"|"l")?
            --- Function that handles navigation between windows.
            --- Defaults to `vim.cmd.wincmd`. Used by the `nav_*` keymaps.
            nav = nil,
          },
          ---@class sidekick.cli.Mux
          ---@field backend? "tmux"|"zellij" Multiplexer backend to persist CLI sessions
          mux = {
            backend = "tmux", -- default to tmux unless zellij is detected
            enabled = true,
            create = "split", ---@type "terminal"|"window"|"split"
            split = {
              vertical = true, -- vertical or horizontal split
              size = 0.3, -- size of the split (0-1 for percentage)
            },
          },
          ---@type table<string, sidekick.cli.Config|{}>
          tools = {
            bdtui = { cmd = { "bdtui" } },
            aider = { cmd = { "aider" } },
            amazon_q = { cmd = { "q" } },
            claude = { cmd = { "claude" } },
            codex = { cmd = { "codex", "--enable", "web_search_request" } },
            beanstui = { cmd = { "beans", "tui" } },
            copilot = { cmd = { "copilot", "--banner" } },
            crush = {
              cmd = { "crush" },
              -- crush uses <a-p> for its own functionality, so we override the default
              keys = { prompt = { "<a-p>", "prompt" } },
            },
            cursor = { cmd = { "cursor-agent" } },
            gemini = { cmd = { "gemini" } },
            grok = { cmd = { "grok" } },
            opencode = {
              cmd = { "opencode" },
              -- HACK: https://github.com/sst/opencode/issues/445
              env = { OPENCODE_THEME = "system" },
            },
            qwen = { cmd = { "qwen" } },
            kilocode = { cmd = { "kilocode" } },
            amp = { cmd = { "amp", "--ide" } },
          },
          --- Add custom context. See `lua/sidekick/context/init.lua`
          ---@type table<string, sidekick.context.Fn>
          context = {},
          ---@type table<string, sidekick.Prompt|string|fun(ctx:sidekick.context.ctx):(string?)>
          prompts = {
            changes = "Можешь проверить мои изменения?",
            diagnostics = "Поможешь исправить диагностические ошибки в {file}?\n{diagnostics}",
            diagnostics_all = "Поможешь исправить эти диагностические ошибки?\n{diagnostics_all}",
            document = "Добавь документацию к {function|line}",
            explain = "Объясни {this}",
            fix = "Можешь исправить {this}?",
            optimize = "Как можно оптимизировать {this}?",
            review = "Можешь проверить {file} на ошибки или улучшения?",
            tests = "Можешь написать тесты для {this}?",
            -- simple context prompts
            buffers = "{buffers}",
            file = "{file}",
            line = "{line}",
            position = "{position}",
            quickfix = "{quickfix}",
            selection = "{selection}",
            ["function"] = "{function}",
            class = "{class}",
          },
          -- preferred picker for selecting files
          ---@alias sidekick.picker "snacks"|"telescope"|"fzf-lua"
          picker = "snacks", ---@type sidekick.picker
        },
        copilot = { status = { enabled = false } },
        ui = {
          icons = {
            attached = " ",
            started = " ",
            installed = " ",
            missing = " ",
            external_attached = "󰖩 ",
            external_started = "󰖪 ",
            terminal_attached = " ",
            terminal_started = " ",
          },
        },
        debug = false, -- enable debug logging
      })
    end,
  },
})

-- ---------------------------
-- NOTE: ARCHIVE
-- ----------------------------
--[[
  { "stevearc/dressing.nvim", opts = {} }, -- ui for other plug_configs -- deprecated
  u.safe_require("plug_configs.search.fzflua"), -- до лучших времен
  u.safe_require("plug_configs.ui.hlchunk"), -- highlight chunk (indent)

  --]]
