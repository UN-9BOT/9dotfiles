local M = {
  "3rd/image.nvim",
  build = false,
  ft = { "markdown", "vimwiki" },
}

M.config = function()
  require("image").setup({
    backend = "kitty",
    processor = "magick_cli",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = true,
        only_render_image_at_cursor_mode = "popup",
        floating_windows = true,
        filetypes = { "markdown", "vimwiki" },
      },
      html = {
        enabled = false,
      },
      css = {
        enabled = false,
      },
    },
    kitty_method = "normal",
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    editor_only_render_when_focused = true,
    tmux_show_only_in_active_window = true,
  })
end

return M
