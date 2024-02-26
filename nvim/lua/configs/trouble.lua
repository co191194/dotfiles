local trouble = require("trouble")
trouble.setup({
  use_diagnotic_signs = true,
})

-- Lua
vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end)
vim.keymap.set("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() trouble.toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() trouble.toggle("loclist") end)
vim.keymap.set("n", "gR", function() trouble.toggle("lsp_references") end)

vim.keymap.set('n', 'gn', function() trouble.next { skip_groups = true, jump = true } end)
vim.keymap.set('n', 'gp', function() trouble.previous { skip_groups = true, jump = true } end)
vim.keymap.set('n', 'gF', function() trouble.first { skip_groups = true, jump = true } end)
vim.keymap.set('n', 'gL', function() trouble.last { skip_groups = true, jump = true } end)
