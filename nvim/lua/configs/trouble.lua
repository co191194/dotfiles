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

wk.register({
  ["<leader>"] = {
    x = {
      name = "Trouble",
      x = {
        function()
          trouble.toggle("diagnostics")
        end,
        "Toggle Trouble",
      },
      X = {
        function()
          trouble.toggle("diagnostics_buffer")
        end,
        "Toggle Trouble: Diagnostics Buffer",
      },
      w = {
        function()
          trouble.toggle("diagnostics")
        end,
        "Toggle Trouble: Workspace Diagnostics",
      },
      d = {
        function()
          trouble.toggle("document_diagnostics")
        end,
        "Toggle Trouble: Document Diagnostics",
      },
      q = {
        function()
          trouble.toggle("quickfix")
        end,
        "Toggle Trouble: QuickFix",
      },
      l = {
        function()
          trouble.toggle("loclist")
        end,
        "Toggle Trouble: loclist",
      },
      p = {
        function()
          trouble.toggle("preview_float")
        end,
        "Toggle Trouble: preview_float",
      },
    },
  },
  g = {
    R = {
      function()
        trouble.toggle("lsp_references")
      end,
      "Toggle Trouble: LSP References",
    },
    n = {
      function()
        trouble.next(opts)
      end,
      "Next Trouble",
    },
    p = {
      function()
        trouble.prev(opts)
      end,
      "Prev Trouble",
    },
    F = {
      function()
        trouble.first(opts)
      end,
      "First Trouble",
    },
    L = {
      function()
        trouble.last(opts)
      end,
      "Last Trouble",
    },
  },
})
