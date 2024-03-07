local notify = require("notify")

notify.setup({
  background_colour = "#000000",
  fps = 30,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "✎",
    WARN = "",
  },
  level = 2,
  minimum_width = 50,
  render = "default",
  stages = "fade_in_slide_out",
  time_formats = {
    notification = "%T",
    notification_history = "%FT%T",
  },
  timeout = 5000,
  top_down = true,
})
vim.notify = notify

local telescope = require("telescope")
telescope.load_extension("notify")
vim.keymap.set("n", "<leader>fn", function()
  telescope.extensions.notify.notify()
end, {})
