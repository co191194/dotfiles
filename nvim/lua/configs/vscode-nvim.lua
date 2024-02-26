-- 背景色
vim.o.background = "dark"

-- vscode.nvimで提供されている色
local c = require("vscode.colors").get_colors()

require("vscode").setup({
  -- 背景色を透明にする・しない
  transparent = true,
  -- コメントアウトをイタリックにする・しない
  italic_comments = true,
  -- vscode.nvimの色設定を上書きする。(see ./lua/vscode/colors.lua)
  color_overrides = {
    -- 行番号の文字色
    vscLineNumber = "#DDDDDD",
  },
  -- Override highlight groups (see ./lua/vscode/theme.lua)
  group_overrides = {
    -- this supports the same val table as vim.api.nvim_set_hl
    -- use colors from this colorscheme by requiring vscode.colors!
    Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
  },
})
