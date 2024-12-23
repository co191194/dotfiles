local toggleterm = require("toggleterm")
toggleterm.setup({
  open_mapping = { [[<c-\>]], [[<c-¥>]] },
  on_open = function()
    vim.cmd("startinsert")
  end,
})

local wk = require("which-key")

local Terminal = require("toggleterm.terminal").Terminal
local shell = Terminal:new({ hidden = true, direction = "float" })

wk.add({
  noremap = true,
  silent = true,
  mode = { "n", "t" },
  {
    "<M-d>",
    function()
      shell:toggle()
    end,
  },
  {
    "<space>to",
    function ()
      toggleterm.toggle_all()
    end
  }
})

local function set_terminal_keymap()
  wk.add({
    buffer = 0,
    mode = { "t" },
    { "<esc>", [[<C-\><C-n>]], desc = "Change Normal Mode" },
    { "<C-h>", [[<cmd>wincmd h<cr>]], desc = "Move Left Window" },
    { "<C-j>", [[<cmd>wincmd j<cr>]], desc = "Move Down Window" },
    { "<C-k>", [[<cmd>wincmd k<cr>]], desc = "Move Up Window" },
    { "<C-l>", [[<cmd>wincmd l<cr>]], desc = "Move Right Window" },
    { "<C-w>", [[<C-\><C-n><C-w>]], desc = "WinCmd" },
  })
end

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = vim.api.nvim_create_augroup("MyToggleTerm", {}),
  pattern = "term://*#toggleterm#*",
  callback = function()
    set_terminal_keymap()
  end,
})
