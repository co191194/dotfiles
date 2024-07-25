require("toggleterm").setup({
  open_mapping = { [[<c-\>]], [[<c-¥>]] },
  on_open = function ()
    vim.cmd("startinsert")
  end
})

local Terminal = require("toggleterm.terminal").Terminal

local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

local shell = Terminal:new({ hidden = true, direction = "float" })

local opts = { noremap = true, silent = true }
map({ "n", "t" }, "<M-d>", function()
  shell:toggle()
end, opts)

