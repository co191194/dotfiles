require("toggleterm").setup({
  open_mapping = { [[<c-\>]], [[c-¥]] },
})

local Terminal = require("toggleterm.terminal").Terminal

---@param mode string
local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

local shell = Terminal:new({ hidden = true, direction = "float" })

local opts = { noremap = true, silent = true }
map({ "n", "t" }, "<M-d>", function()
  shell:toggle()
end, opts)

if vim.fn.executable("lazygit") == 1 then
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

  -- map({ "n", "t" }, "<M-g>", "<cmd>lua lazygit_toggle()<CR>", opts)
  map({ "n", "t" }, "<M-g>", function()
    lazygit:toggle()
  end, opts)
end
