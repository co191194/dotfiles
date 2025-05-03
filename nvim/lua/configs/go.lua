local go = require("go")

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

go.setup({
  lsp_cfg = {
    capabilities = capabilities,
  },
  trouble = true,
  luasnip = true,
})

local fmt_sync_grp = vim.api.nvim_create_augroup("my_fmt_syncgrp", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimports()
  end,
  group = fmt_sync_grp,
})
