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
local keyset = vim.keymap.set
local builtin = require("telescope.builtin")
-- ファイル検索
keyset("n", "<leader>ff", builtin.find_files, {})
-- ドットファイルを検索対象にするファイル検索
keyset("n", "<leader>fF", ":Telescope find_files hidden=true<CR>", {})

-- テキスト検索
keyset("n", "<leader>/", builtin.live_grep, {})

-- gitの操作（git status）
keyset("n", "<leader>gs", builtin.git_status, {})

-- gitの操作（git log）
keyset("n", "<leader>gl", builtin.git_commits, {})

-- バッファの操作
keyset("n", "<leader><space>", builtin.buffers, {})

-- 履歴の操作
keyset("n", "<leader>fo", builtin.oldfiles, {})

-- nvim設定ファイルへのアクセス
keyset("n", "<leader>fN", ":Telescope find_files cwd=~/.config/nvim<CR>", {})

-- カラーテーマの一覧
keyset("n", "<leader>fc", builtin.colorscheme, {})

-- vim_optionsの一覧
keyset("n", "<leader>fv", builtin.vim_options, {})

-- keymapの一覧
keyset("n", "<leader>fk", builtin.keymaps, {})

-- registerの一覧
keyset("n", "<leader>fr", builtin.registers, {})

keyset("n", "<leader>fh", builtin.help_tags, {})
keyset("n", "<leader>h", function()
  builtin.help_tags(themes.get_ivy())
end, {})

-- extensions file_browser keymaps
local myTFB = vim.api.nvim_create_augroup("my_telescope_file_browswe", {})

keyset("n", "<leader>fb", ":Telescope file_browser<CR>", {})

-- open file_browser with the path of the current buffer
keyset("n", "<leader>fB", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })
