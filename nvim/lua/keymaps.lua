local map = vim.keymap.set

map("n", "*", "<Plug>(asterisk-z*)", { noremap = false })
map("n", "#", "<Plug>(asterisk-z#)", { noremap = false })
map("n", "g*", "<Plug>(asterisk-g*)", { noremap = false })
map("n", "g#", "<Plug>(asterisk-g#)", { noremap = false })
map("n", "z*", "<Plug>(asterisk-*)", { noremap = false })
map("n", "gz*", "<Plug>(asterisk-gz*)", { noremap = false })
map("n", "z#", "<Plug>(asterisk-#)", { noremap = false })
map("n", "gz#", "<Plug>(asterisk-gz#)", { noremap = false })

if vim.g.vscode == 1 then
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
