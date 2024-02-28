local config = {}

require("nvim-tree").setup(config)

local api = require("nvim-tree.api")
vim.api.nvim_create_user_command("Ex", function() api.tree.toggle() end, {})
