vim.g.barbar_auto_setup = false -- disable auto-setup

require("barbar").setup({
  -- WARN: do not copy everything below into your config!
  --       It is just an example of what configuration options there are.
  --       The defaults are suitable for most people.

  -- Enable/disable animations
  animation = true,

  -- Automatically hide the tabline when there are this many buffers left.
  -- Set to any value >=0 to enable.
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  exclude_ft = { "javascript" },
  exclude_name = { "package.json" },

  -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
  -- Valid options are 'left' (the default), 'previous', and 'right'
  focus_on_close = "left",

  -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
  hide = { extensions = true, inactive = true },

  -- Disable highlighting alternate buffers
  highlight_alternate = false,

  -- Disable highlighting file icons in inactive buffers
  highlight_inactive_file_icons = false,

  -- Enable highlighting visible buffers
  highlight_visible = true,

  icons = {
    -- Configure the base icons on the bufferline.
    -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
    buffer_index = false,
    buffer_number = false,
    button = "",
    -- Enables / disables diagnostic symbols
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "ﬀ" },
      [vim.diagnostic.severity.WARN] = { enabled = false },
      [vim.diagnostic.severity.INFO] = { enabled = false },
      [vim.diagnostic.severity.HINT] = { enabled = true },
    },
    gitsigns = {
      added = { enabled = true, icon = "+" },
      changed = { enabled = true, icon = "~" },
      deleted = { enabled = true, icon = "-" },
    },
    filetype = {
      -- Sets the icon's highlight group.
      -- If false, will use nvim-web-devicons colors
      custom_colors = false,

      -- Requires `nvim-web-devicons` if `true`
      enabled = true,
    },
    separator = { left = "▎", right = "" },

    -- If true, add an additional separator at the end of the buffer list
    separator_at_end = true,

    -- Configure the icons on the bufferline when modified or pinned.
    -- Supports all the base icon options.
    modified = { button = "●" },
    pinned = { button = "", filename = true },

    -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
    preset = "default",

    -- Configure the icons on the bufferline based on the visibility of a buffer.
    -- Supports all the base icon options, plus `modified` and `pinned`.
    alternate = { filetype = { enabled = false } },
    current = { buffer_index = true },
    inactive = { button = "×" },
    visible = { modified = { buffer_number = false } },
  },

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the minimum padding width with which to surround each tab
  minimum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- Sets the minimum buffer name length.
  minimum_length = 0,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- Set the filetypes which barbar will offset itself for
  sidebar_filetypes = {
    -- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
    NvimTree = true,
    -- Or, specify the text used for the offset:
    undotree = {
      text = "undotree",
      align = "center", -- *optionally* specify an alignment (either 'left', 'center', or 'right')
    },
    -- Or, specify the event which the sidebar executes when leaving:
    ["neo-tree"] = { event = "BufWipeout" },
    -- Or, specify all three
    Outline = { event = "BufWinLeave", text = "symbols-outline", align = "right" },
  },

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustment
  -- for other layouts.
  letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
})

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
