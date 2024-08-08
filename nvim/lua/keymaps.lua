local map = vim.keymap.set

map("n", "*", "<Plug>(asterisk-z*)", { noremap = false })
map("n", "#", "<Plug>(asterisk-z#)", { noremap = false })
map("n", "g*", "<Plug>(asterisk-g*)", { noremap = false })
map("n", "g#", "<Plug>(asterisk-g#)", { noremap = false })
map("n", "z*", "<Plug>(asterisk-*)", { noremap = false })
map("n", "gz*", "<Plug>(asterisk-gz*)", { noremap = false })
map("n", "z#", "<Plug>(asterisk-#)", { noremap = false })
map("n", "gz#", "<Plug>(asterisk-gz#)", { noremap = false })

if require("utils").is_vscode() then
  local vscode = require("vscode")
  map("n", "<leader>ff", function()
    vscode.action("workbench.action.quickOpen")
  end)

  map("n", "<space>bc", function()
    vscode.action("workbench.action.closeActiveEditor")
  end)

  map("n", "<space>o", function()
    vscode.action("workbench.action.gotoSymbol")
  end)

  map("n", "<leader>/", function()
    vscode.action("workbench.action.quickTextSearch")
  end)

  map("n", "<space>f", function()
    vscode.action("editor.action.formatDocument")
  end)

  map("n", "L", function()
    vscode.action("workbench.action.nextEditor")
  end)
  map("n", "H", function()
    vscode.action("workbench.action.previousEditor")
  end)

  map("n", "<space>rn", function()
    vscode.action("editor.action.rename")
  end)

  map("n", "gcc", function()
    vscode.action("editor.action.commentLine")
  end)

  map("n", "gbc", function()
    vscode.action("editor.action.blockComment")
  end)

  map("x", "gc", function()
    vscode.call("editor.action.commentLine")
    vscode.call("vscode-neovim.escape")
  end)
  map("x", "gb", function()
    vscode.call("editor.action.blockComment")
    vscode.call("vscode-neovim.escape")
  end)

else
  -- insertモードの終了
  map("i", "jj", "<ESC>", { noremap = true, silent = true })

  -- 日本語入力時
  map("n", "あ", "a")
  map("n", "い", "i")
  map("n", "う", "u")
  map("n", "え", "e")
  map("n", "お", "o")

  map("i", "<LeftMouse>", "<cmd>stopinsert<cr><LeftMouse>", {})
end
