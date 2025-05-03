local toggleterm = require("toggleterm")
toggleterm.setup({
  -- open_mapping = { [[<c-\>]], [[<c-¥>]] },
  open_mapping = {},
  on_open = function()
    vim.cmd("startinsert")
  end,
})

local wk = require("which-key")

local Terminal = require("toggleterm.terminal").Terminal
---@type Terminal[]
local terms = {}

---@param direction string
local function toggle_term(direction)
  local count = vim.v.count1

  ---@type Terminal
  local terminal
  local is_new_term = true
  for _, term in ipairs(terms) do
    if term.count == count then
      is_new_term = false
      terminal = term
      break
    end
  end

  if is_new_term then
    terminal = Terminal:new({
      hidden = true,
      count = count,
      direction = direction
    })
    table.insert(terms, terminal)
  elseif not (terminal.direction == direction) then
    terminal.direction = direction
    terminal:close()
  end
  terminal:toggle()
end

local function toggle_term_all()
  local is_any_open = false
  for _, term in ipairs(terms) do
    if term:is_open() then
      is_any_open = true
      break
    end
  end

  for _, term in ipairs(terms) do
    if is_any_open then
      term:close()
    else
      term:open()
    end
  end
end

local function toggle_horizontal_term()
  toggle_term("horizontal")
end

local function toggle_float_term()
  toggle_term("float")
end

wk.add({
  noremap = true,
  silent = true,
  mode = { "n", "t" },
  { "<C-\\>", toggle_horizontal_term },
  { "<M-d>", toggle_float_term },
  { "<C-c>", toggle_term_all },
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
    { "<C-w>w", [[<cmd>wincmd w<cr>]], desc = "WinCmd" },
    { "<C-w><C-w>", [[<cmd>wincmd w<cr>]], desc = "WinCmd" },
  })
end
local group = vim.api.nvim_create_augroup("MyToggleTerm", {})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = group,
  pattern = "term://*#toggleterm#*",
  callback = set_terminal_keymap,
})

local function close_term_all()
  for _, term in ipairs(terms) do
    term:close()
  end
end

vim.api.nvim_create_autocmd({ "QuitPre" }, {
  group = group,
  callback = close_term_all,
})
