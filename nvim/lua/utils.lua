local M = {}

---add new keymap
---@param mode string | table 
---@param lhs string
---@param rhs string | function
---@param opts table | nil
M.map = function (mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.is_vscode = function ()
  return vim.g.vscode == 1
end

return M
