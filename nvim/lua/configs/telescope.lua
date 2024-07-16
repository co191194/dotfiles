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
local wk = require("which-key")
wk.add({
  { "<leader>/", ":Telescope live_grep<cr>", desc = "Live Grep Text" },
  { "<leader><space>", ":Telescope buffers<cr>", desc = "Find Buffer" },
  { "<leader>f", group = "Telescope Find" },
  {
    "<leader>fB",
    ":Telescope file_browser path=%:p:help select_buffer=true<CR>",
    desc = "Open File Browser With Current Buffer",
  },
  {
    "<leader>fF",
    ":Telescope find_files hidden=true<CR>",
    desc = "Find File(Include Hidden Files)",
  },
  {
    "<leader>fN",
    ":Telescope find_files cwd=~/.config/nvim<CR>",
    desc = "Find Nvim Setting File",
  },
  { "<leader>fb", ":Telescope file_browser<CR>", desc = "Open File Browser" },
  { "<leader>fc", ":Telescope colorscheme<cr>", desc = "Find Color Scheme" },
  { "<leader>ff", ":Telescope find_files<cr>", desc = "Find File" },
  { "<leader>fh", ":Telescope help_tags<cr>", desc = "Find Help" },
  { "<leader>fk", ":Telescope keymaps<cr>", desc = "Find Keymap" },
  { "<leader>fo", ":Telescope oldfiles<cr>", desc = "Find Old File" },
  { "<leader>fr", ":Telescope registers<cr>", desc = "Find Register" },
  { "<leader>fv", ":Telescope vim_options<cr>", desc = "Find Vim Option" },
  { "<leader>g", group = "Telescope Git" },
  { "<leader>gl", ":Telescope git_status<cr>", desc = "Git Log" },
  { "<leader>gs", ":Telescope git_commits<cr>", desc = "Git Status" },
})
