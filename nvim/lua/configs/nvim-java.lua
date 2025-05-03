local M = {}

local wk = require("which-key")

M.on_attach = function(_, bufnr)
  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })

  require("lsp_signature").on_attach({
    bind = true,
    padding = "",
    handler_opts = {
      border = "rounded",
    },
    hint_prefix = "󱄑 ",
  }, bufnr)

end

M.keymap = function()
  local group = vim.api.nvim_create_augroup("MyJavaKeymap", {})
  vim.api.nvim_create_autocmd({"BufEnter"}, {
    group = group,
    pattern = "*.java",
    callback = function ()
      wk.add({
        {lhs =  "<space>f", rhs = "<cmd>Format<cr>", desc = "Java: Format"} })
    end

  })
end

return M
