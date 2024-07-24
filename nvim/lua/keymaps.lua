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
  -- ターミナルモードのキーマップ
  map("t", "<Esc><Esc>", [[<C-\><C-n>]])
  -- map("t", "<C-w>", [[<C-\><C-n><C-w>]])
  -- insertモードの終了
  map("i", "jj", "<ESC>", { noremap = true, silent = true })

  -- 日本語入力時
  map("n", "あ", "a")
  map("n", "い", "i")
  map("n", "う", "u")
  map("n", "え", "e")
  map("n", "お", "o")

  -- Autocomplete
  function _G.check_back_space()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
  end

  -- ここからcocのキーマップ
  if vim.fn.exists("coc") == 1 then
    -- 補完機能が表示されているときにtabで選択する
    -- Use Tab for trigger completion with characters ahead and navigate
    -- NOTE: There's always a completion item selected by default, you may want to enable
    -- no select by setting `"suggest.noselect": true` in your configuration file
    -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
    -- other plugins before putting this into your config
    local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
    map(
      "i",
      "<TAB>",
      'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
      opts
    )
    map("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

    -- 保管機能でenterを押したときに改行しないようにする
    -- Make <CR> to accept selected completion item or notify coc.nvim to format
    -- <C-g>u breaks current undo, please make your own choice
    map("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
  end

  map("i", "<LeftMouse>", "<cmd>stopinsert<cr><LeftMouse>", {})
end
