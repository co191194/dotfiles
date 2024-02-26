require("toggleterm").setup()
local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

map("n", "<M-d>", "<cmd>ToggleTerm size=40 direction=float name=workspace<CR>")
map("t", "<M-d>", "<C-\\><C-n><cmd>ToggleTerm name=workspace<CR>")

local Terminal = require("toggleterm.terminal").Terminal
if vim.fn.executable("lazygit") == 1 then
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
  function _G.lazygit_toggle()
    lazygit:toggle()
  end

  map({"n", "t"}, "<M-g>", "<cmd>lua lazygit_toggle()<CR>", { noremap = true, silent = true })
end
