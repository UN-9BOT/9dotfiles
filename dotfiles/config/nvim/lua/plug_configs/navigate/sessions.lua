return {
  "jedrzejboczar/possession.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local possession = require("possession")

    possession.setup({
      autoload = "last_cwd",
      plugins = {
        delete_hidden_buffers = {
          hooks = {
            "before_load",
            vim.o.sessionoptions:match("buffer") and "before_save",
          },
          force = true,
        },
        delete_buffers = true,
        stop_lsp_clients = true,
      },
      -- plugins = { delete_hidden_buffers = false, delete_buffers = true }, -- NOTE: предыдущая реализация
      -- autosave = { current = true, cwd = true },  -- XXX: не работает с neotest
      hooks = {
        before_load = function(name, user_data)
          return user_data
        end,
      },
    })

    require("possession.utils").stop_lsp_clients = function()
      local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients

      for _, client in ipairs(get_clients()) do
        client:stop()
      end
    end

    -- NOTE:  Фикс для neotest
    vim.api.nvim_create_autocmd("ExitPre", {
      callback = function()
        vim.cmd("PossessionSaveCwd!")
      end,
    })
  end,
}
