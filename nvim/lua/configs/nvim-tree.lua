local api = require("nvim-tree.api")
local set = vim.keymap.set
local treeutils = require("treeutils")

local function open_tab_silent(node)
  api.node.open.tab(node)
  vim.cmd.tabprevious()
end

local function my_on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
  set("n", "<C-h>", api.tree.toggle_help, opts("Help"))
  set("n", "T", open_tab_silent, opts("Open Tab Silent"))
  set("n", "<C-f>", treeutils.launch_find_files, opts("Launch Find Files"))
  set("n", "<C-g>", treeutils.launch_live_grep, opts("Launch Live Grep"))
end

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
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = false,
  },
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

local group = vim.api.nvim_create_augroup("MyNTree", {})
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = group,
--   nested = true,
--   callback = function()
--     if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
--       vim.cmd "quit"
--     end
--   end
-- })
