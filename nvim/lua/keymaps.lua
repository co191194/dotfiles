local keyset = vim.keymap.set
local ex_keyset = vim.api.nvim_set_keymap

keyset("n", "*", "<Plug>(asterisk-*)", { noremap = false })
keyset("n", "#", "<Plug>(asterisk-#)", { noremap = false })
keyset("n", "g*", "<Plug>(asterisk-g*)", { noremap = false })
keyset("n", "g#", "<Plug>(asterisk-g#)", { noremap = false })
keyset("n", "z*", "<Plug>(asterisk-z*)", { noremap = false })
keyset("n", "gz*", "<Plug>(asterisk-gz*)", { noremap = false })
keyset("n", "z#", "<Plug>(asterisk-z#)", { noremap = false })
keyset("n", "gz#", "<Plug>(asterisk-gz#)", { noremap = false })

if vim.g.vscode == 1 then
else
  -- ターミナルモードのキーマップ
  keyset("t", "<Esc>", [[<C-\><C-n>]])
  keyset("t", "<C-w>", [[<C-\><C-n><C-w>]])
  keyset("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
  keyset("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })
  --keyset("t", "<C-W>", "<C-\\><C-N><C-W>")
  -- insertモードの終了
  keyset("i", "jj", "<ESC>", { noremap = true, silent = true })

  -- 日本語入力時
  keyset("n", "あ", "a")
  keyset("n", "い", "i")
  keyset("n", "う", "u")
  keyset("n", "え", "e")
  keyset("n", "お", "o")

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
    keyset(
      "i",
      "<TAB>",
      'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
      opts
    )
    keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

    -- 保管機能でenterを押したときに改行しないようにする
    -- Make <CR> to accept selected completion item or notify coc.nvim to format
    -- <C-g>u breaks current undo, please make your own choice
    keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
  end
end
