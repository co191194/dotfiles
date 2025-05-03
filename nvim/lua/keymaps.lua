local map = vim.keymap.set

map("n", "*", "<Plug>(asterisk-z*)", { noremap = false })
map("n", "#", "<Plug>(asterisk-z#)", { noremap = false })
map("n", "g*", "<Plug>(asterisk-g*)", { noremap = false })
map("n", "g#", "<Plug>(asterisk-g#)", { noremap = false })
map("n", "z*", "<Plug>(asterisk-*)", { noremap = false })
map("n", "gz*", "<Plug>(asterisk-gz*)", { noremap = false })
map("n", "z#", "<Plug>(asterisk-#)", { noremap = false })
map("n", "gz#", "<Plug>(asterisk-gz#)", { noremap = false })

map("i", "<c-p>", "<Up>")
map("i", "<c-n>", "<Down>")
map("i", "<c-f>", "<Right>")
map("i", "<c-b>", "<Left>")
map("i", "<c-a>", "<Home>")
map("i", "<c-e>", "<End>")
map("i", "<c-h>", "<BS>")
map("i", "<c-d>", "<Del>")

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

  map("n", "<space>rn", function()
    vscode.action("editor.action.rename")
  end)

  -- toggle comment out for line
  map("n", "gcc", function()
    vscode.action("editor.action.commentLine")
  end)

  -- toggle block comment out for line
  map("n", "gbc", function()
    vscode.action("editor.action.blockComment")
  end)

  -- toggle comment out for selected range
  map("x", "gc", function()
    vscode.call("editor.action.commentLine")
    vscode.call("vscode-neovim.escape")
  end)

  -- toggle block comment out for selected range
  map("x", "gb", function()
    vscode.call("editor.action.blockComment")
    vscode.call("vscode-neovim.escape")
  end)

  -- close all panel and bar
  map("n", "<leader>z", function ()
    vscode.action("workbench.action.closeAuxiliaryBar")
    vscode.action("workbench.action.closePanel")
    vscode.action("workbench.action.closeSidebar")
  end)

  map("n", "<leader>t", function ()
    vscode.action("workbench.action.terminal.toggleTerminal")
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
