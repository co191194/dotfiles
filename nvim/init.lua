vim.loader.enable()

-- nvim settings
require("settings")
-- plugins settings
require("plugins")
-- keymaps
require("keymaps")

-- not call nvim by vscode
if not require("utils").is_vscode() then
  -- setting colorscheme
  vim.cmd.colorscheme("vscode")
end
