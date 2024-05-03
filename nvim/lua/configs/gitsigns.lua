require("gitsigns").setup({
  signs = {
    add = { hl = "GitSignsAdd", text = " │", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = " │", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    untracked = { hl = "GitSignsAdd", text = "┆ ", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
  on_attach = function(_)
    local gs = package.loaded.gitsigns

    local map = vim.keymap.set
    local function opts(options, desc)
      options.desc = "gitsigns: " .. desc
      return options
    end
    ---expr = true and desc
    ---@param desc string
    ---@return table
    local function opts1(desc)
      return opts({ expr = true }, desc)
    end
    ---noremap = true and desc
    ---@param desc string
    ---@return table
    local function opts2(desc)
      return opts({ noremap = true }, desc)
    end
    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, opts1("next_hunk"))

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, opts1("prev_hunk"))

    -- Actions
    map("n", "<leader>hs", gs.stage_hunk, opts2("stage_hunk"))
    map("n", "<leader>hr", gs.reset_hunk, opts2("reset_hunk"))
    map("v", "<leader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, opts2("select stage_hunk"))
    map("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, opts2("select reset_hunk"))
    map("n", "<leader>hS", gs.stage_buffer, opts2("stage_buffer"))
    map("n", "<leader>hu", gs.undo_stage_hunk, opts2("undo_stage_hunk"))
    map("n", "<leader>hR", gs.reset_buffer, opts2("reset_buffer"))
    map("n", "<leader>hp", gs.preview_hunk, opts2("preview_hunk"))
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end, opts2("blame_line"))
    map("n", "<leader>tb", gs.toggle_current_line_blame, opts2("toggle_current_line_blame"))
    map("n", "<leader>hd", gs.diffthis, opts2("diffthis"))
    map("n", "<leader>hD", function()
      gs.diffthis("~")
    end, opts2("diffthis ~"))
    map("n", "<leader>td", gs.toggle_deleted, opts2("toggle_deleted"))

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", opts2("select_hunk"))
  end,
})
