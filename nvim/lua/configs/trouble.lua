local trouble = require("trouble")
trouble.setup({
  modes = {
    preview_float = {
      mode = "diagnostics",
      preview = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        position = { 0, -2 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
      },
    },
    diagnostics_buffer = {
      mode = "diagnostics", -- inherit from diagnostics mode
      filter = { buf = 0 }, -- filter diagnostics to the current buffer
    },
  },
})

local wk = require("which-key")
local opts = { mode = "diagnostics", skip_groups = true, jump = true }

wk.add({
  { "<leader>x", group = "Trouble" },
  { "<leader>xX", "<cmd>Trouble diagnostics_buffer toggle<cr>", desc = "Toggle Trouble: Diagnostics Buffer" },
  { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Toggle Trouble: loclist" },
  { "<leader>xp", "<cmd>Trouble preview_float toggle<cr>", desc = "Toggle Trouble: preview_float" },
  { "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", desc = "Toggle Trouble: QuickFix" },
  { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Trouble" },
  { "gF", "<cmd>Trouble diagnostics first<cr>", desc = "First Trouble" },
  { "gL", "<cmd>Trouble diagnostics last<cr>", desc = "Last Trouble" },
  { "gR", "<cmd>Trouble lsp_references toggle<cr>", desc = "Toggle Trouble: LSP References" },
  { "gn", "<cmd>Trouble diagnostics next<cr>", desc = "Next Trouble" },
  { "gp", "<cmd>Trouble diagnostics prev<cr>", desc = "Prev Trouble" },
})
