local themes = require("telescope.themes")
local actions = require("telescope.actions")
local fb_actions = require("telescope").extensions.file_browser.actions
local telescope = require("telescope")
local trouble = require("trouble.sources.telescope")
telescope.setup({
  defaults = {
    file_ignore_patterns = {
      -- 検索から除外するものを指定
      "^.git/",
      "^.cache/",
      "^Library/",
      "Parallels",
      "^Movies",
      "^Music",
    },
    vimgrep_arguments = {
      -- ripggrepコマンドのオプション
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "-uu",
    },
    mappings = {
      i = {
        ["<C-h>"] = actions.which_key,
        ["<esc>"] = actions.close,
        ["<C-t>"] = trouble.open,
      },
      n = {
        ["<C-h>"] = actions.which_key,
        ["<C-t>"] = trouble.open,
      },
    },
  },
  extensions = {
    -- ソート性能を向上させるfzfを使う
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          ["<A-h>"] = fb_actions.toggle_hidden,
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
})
telescope.load_extension("fzf")
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
telescope.load_extension("file_browser")

-- telescopeのキーマップ
local builtin = require("telescope.builtin")
local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    f = {
      name = "Telescope Find",
      f = { builtin.find_files, "Find File" },
      F = { ":Telescope find_files hidden=true<CR>", "Find File(Include Hidden Files)" },
      o = { builtin.oldfiles, "Find Old File" },
      N = { ":Telescope find_files cwd=~/.config/nvim<CR>", "Find Nvim Setting File" },
      c = { builtin.colorscheme, "Find Color Scheme" },
      v = { builtin.vim_options, "Find Vim Option" },
      k = { builtin.keymaps, "Find Keymap" },
      r = { builtin.registers, "Find Register" },
      h = { builtin.help_tags, "Find Help" },
      b = { ":Telescope file_browser<CR>", "Open File Browser" },
      B = {
        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        "Open File Browser With Current Buffer",
      },
    },
    g = {
      name = "Telescope Git",
      s = { builtin.git_status, "Git Status" },
      l = { builtin.git_commits, "Git Log" },
    },
    ["/"] = { builtin.live_grep, "Live Grep Text" },
    ["<space>"] = { builtin.buffers, "Find Buffer" },
  },
})
