vim.g.barbar_auto_setup = false -- disable auto-setup

require("barbar").setup({})

local wk = require("which-key")
local api = require("barbar.api")

wk.register({
  -- Move to previous/next
  ["<A-,>"] = { "<Cmd>BufferPrevious<CR>", "prev buffer" },
  ["<A-.>"] = { "<Cmd>BufferNext<CR>", "next buffer" },
  -- Re-order to previous/next
  ["<A-<>"] = { "<Cmd>BufferMovePrevious<CR>", "prev move buffer" },
  ["<A->>"] = { "<Cmd>BufferMoveNext<CR>", "next move buffer" },
  -- Goto buffer in position...
  ["<A-1>"] = { "<Cmd>BufferGoto 1<CR>", "goto buf 1" },
  ["<A-2>"] = { "<Cmd>BufferGoto 2<CR>", "goto buf 2" },
  ["<A-3>"] = { "<Cmd>BufferGoto 3<CR>", "goto buf 3" },
  ["<A-4>"] = { "<Cmd>BufferGoto 4<CR>", "goto buf 4" },
  ["<A-5>"] = { "<Cmd>BufferGoto 5<CR>", "goto buf 5" },
  ["<A-6>"] = { "<Cmd>BufferGoto 6<CR>", "goto buf 6" },
  ["<A-7>"] = { "<Cmd>BufferGoto 7<CR>", "goto buf 7" },
  ["<A-8>"] = { "<Cmd>BufferGoto 8<CR>", "goto buf 8" },
  ["<A-9>"] = { "<Cmd>BufferGoto 9<CR>", "goto buf 9" },
  ["<A-0>"] = { "<Cmd>BufferLast<CR>", "goto buf last" },
  -- Pin/unpin buffer
  ["<A-p>"] = { "<Cmd>BufferPin<CR>", "pin buffer" },
  -- Close buffer
  ["<A-c>"] = { "<Cmd>BufferClose<CR>", "close buffer" },
  -- Wipeout buffer
  --                 :BufferWipeout
  -- Close commands
  --                 :BufferCloseAllButCurrent
  --                 :BufferCloseAllButPinned
  --                 :BufferCloseAllButCurrentOrPinned
  --                 :BufferCloseBuffersLeft
  --                 :BufferCloseBuffersRight
  -- Magic buffer-picking mode
  ["<C-p>"] = { "<Cmd>BufferPick<CR>", "pick buffer" },
  -- Sort automatically by...
  ["<Space>"] = {
    b = {
      name = "barbar",
      b = { "<Cmd>BufferOrderByBufferNumber<CR>", "order by buf number" },
      n = { "<Cmd>BufferOrderByName<CR>", "order by buf name" },
      d = { "<Cmd>BufferOrderByDirectory<CR>", "order by directory" },
      l = { "<Cmd>BufferOrderByLanguage<CR>", "order by language" },
      w = { "<Cmd>BufferOrderByWindowNumber<CR>", "order by window number" },
      a = {
        name = "Close All",
        c = { api.close_all_but_current, "Close All But Current" },
        v = { api.close_all_but_visible, "Close All But Visible" },
        r = { api.close_buffers_right, "Close Right All" },
        l = { api.close_buffers_left, "Close Left All" },
      },
    },
  },

  -- Other:
  -- :BarbarEnable - enables barbar (enabled by default)
  -- :BarbarDisable - very bad command, should never be used
}, { noremap = true, silent = true })
