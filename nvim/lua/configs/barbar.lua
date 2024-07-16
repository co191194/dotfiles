vim.g.barbar_auto_setup = false -- disable auto-setup

require("barbar").setup({})

local wk = require("which-key")
local api = require("barbar.api")

wk.add(  {
    { "<A-,>", "<Cmd>BufferPrevious<CR>", desc = "prev buffer", remap = false },
    { "<A-.>", "<Cmd>BufferNext<CR>", desc = "next buffer", remap = false },
    { "<A-0>", "<Cmd>BufferLast<CR>", desc = "goto buf last", remap = false },
    { "<A-1>", "<Cmd>BufferGoto 1<CR>", desc = "goto buf 1", remap = false },
    { "<A-2>", "<Cmd>BufferGoto 2<CR>", desc = "goto buf 2", remap = false },
    { "<A-3>", "<Cmd>BufferGoto 3<CR>", desc = "goto buf 3", remap = false },
    { "<A-4>", "<Cmd>BufferGoto 4<CR>", desc = "goto buf 4", remap = false },
    { "<A-5>", "<Cmd>BufferGoto 5<CR>", desc = "goto buf 5", remap = false },
    { "<A-6>", "<Cmd>BufferGoto 6<CR>", desc = "goto buf 6", remap = false },
    { "<A-7>", "<Cmd>BufferGoto 7<CR>", desc = "goto buf 7", remap = false },
    { "<A-8>", "<Cmd>BufferGoto 8<CR>", desc = "goto buf 8", remap = false },
    { "<A-9>", "<Cmd>BufferGoto 9<CR>", desc = "goto buf 9", remap = false },
    { "<A-<>", "<Cmd>BufferMovePrevious<CR>", desc = "prev move buffer", remap = false },
    { "<A->>", "<Cmd>BufferMoveNext<CR>", desc = "next move buffer", remap = false },
    { "<A-c>", "<Cmd>BufferClose<CR>", desc = "close buffer", remap = false },
    { "<A-p>", "<Cmd>BufferPin<CR>", desc = "pin buffer", remap = false },
    { "<C-p>", "<Cmd>BufferPick<CR>", desc = "pick buffer", remap = false },
    { "<Space>b", group = "barbar", remap = false },
    { "<Space>ba", group = "Close All", remap = false },
    { "<Space>bac", api.close_all_but_current, desc = "Close All But Current", remap = false },
    { "<Space>bal", api.close_buffers_left, desc = "Close Left All", remap = false },
    { "<Space>bar", api.close_buffers_right, desc = "Close Right All", remap = false },
    { "<Space>bav", api.close_all_but_visible, desc = "Close All But Visible", remap = false },
    { "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", desc = "order by buf number", remap = false },
    { "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", desc = "order by directory", remap = false },
    { "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", desc = "order by language", remap = false },
    { "<Space>bn", "<Cmd>BufferOrderByName<CR>", desc = "order by buf name", remap = false },
    { "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", desc = "order by window number", remap = false },
  })

