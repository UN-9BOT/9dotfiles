-- NOTE: sidekick.nvim + herdr backend for sidekick (nvim-herdr-sidekick)
-- REF: https://github.com/folke/sidekick.nvim

local sidekick = {
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
          backend = "herdr", -- default to tmux unless zellij is detected
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
}

local herdr = {
  "anthonycirc/nvim-herdr-sidekick",
  dependencies = { "folke/sidekick.nvim" },
  cond = function()
    return vim.env.HERDR_ENV == "1"
  end,
  event = "VeryLazy",
  opts = {},
}

return { sidekick, herdr }
