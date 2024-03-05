require("toggleterm").setup()
local Terminal = require("toggleterm.terminal").Terminal
local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

local shell_cmd
if vim.fn.has("win32") == 1 then
  shell_cmd = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
elseif vim.fn.has("unix") == 1 then
  shell_cmd = "bash"
end

local shell = Terminal:new({ cmd = shell_cmd, hidden = true, direction = "float" })

local opts = { noremap = true, silent = true }
-- map({"n", "t"}, "<M-d>", "<cmd>ToggleTerm size=40 direction=float name=workspace<CR>")
map({ "n", "t" }, "<M-d>", function()
  shell:toggle()
end, opts)

if vim.fn.executable("lazygit") == 1 then
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
  function _G.lazygit_toggle()
    lazygit:toggle()
  end

  map({ "n", "t" }, "<M-g>", "<cmd>lua lazygit_toggle()<CR>", opts)
end
