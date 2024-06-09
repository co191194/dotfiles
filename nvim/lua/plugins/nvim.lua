-- Get platform dependant build script
local function tabnine_build_path()
  -- Replace vim.uv with vim.loop if using NVIM 0.9.0 or below
  if vim.uv.os_uname().sysname == "Windows_NT" then
    return "pwsh.exe -file .\\dl_binaries.ps1"
  else
    return "./dl_binaries.sh"
  end
end

return {
  -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    -- or	, branch = '0.1.x',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      require("configs/telescope")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("configs/nvim-treesitter")
    end,
  },
  "vim-scripts/ScrollColors",
  "sainnhe/everforest",
  "tomasiser/vim-code-dark",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("configs/lualine")
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("configs.toggleterm")
    end,
  },
  "rust-lang/rust.vim",
  "EdenEast/nightfox.nvim",
  {
    "Mofiqul/vscode.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("configs/vscode-nvim")
    end,
  },
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "b0o/schemastore.nvim",
  -- 'MunifTanjim/prettier.nvim',
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    -- config = function()
    --   require("your.null-ls.config") -- require your null-ls config here (example below)
    -- end,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    -- install jsregexp (optional!).
    -- build = "make install_jsregexp",
    config = function()
      require("configs.luasnip")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
    },
  },
  { "mfussenegger/nvim-jdtls" },
  { "folke/neodev.nvim", opts = {} },
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs/nvim-lspconfig")
      require("configs/nvim-cmp")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("configs/gitsigns")
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("configs.nvim-scrollbar")
    end,
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim",
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("nvim-navic").setup({
        lsp = {
          auto_attach = true,
          preference = {
            "volar",
            "tsserver",
          },
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      --   -- or leave it empty to use the default settings
      --     -- refer to the configuration section below
    },
    config = function()
      require("configs.trouble")
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      require("configs.nvim-notify")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("configs.indent-blankline")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("configs.nvim-tree")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("configs.noice")
    end,
  },
  -- {
  --   "codota/tabnine-nvim",
  --   build = tabnine_build_path(),
  --   config = function()
  --     require("configs.tabnine")
  --   end,
  -- },
}
