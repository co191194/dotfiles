-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local api = require("nvim-tree.api")

local function my_on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
  vim.keymap.set("n", "<C-h>", api.tree.toggle_help, opts("Help"))
end

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  on_attach = my_on_attach,
})

vim.api.nvim_create_user_command("Ex", function()
  vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
  api.tree.toggle()
end, {})

---@param desc string
local function opts(desc)
  return { desc = "nvim-tree: " .. desc }
end

vim.keymap.set("n", "<leader>tt", [[<cmd>Ex<CR>]], opts("toggle tree"))

vim.keymap.set("n", "<leader>tf", function()
  vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
  api.tree.focus()
end, opts("focus tree"))
