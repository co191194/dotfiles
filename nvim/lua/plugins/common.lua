return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true,
  },
  -- "rhysd/clever-f.vim",
  {
    "smoka7/hop.nvim",
    version = "v2",
    config = function()
      require("configs.hop")
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = true,
    keys = {
      {
        "<leader>L",
        function()
          vim.schedule(function()
            if require("hlslens").exportLastSearchToQuickfix() then
              vim.cmd("cw")
            end
          end)
          return ":noh<CR>"
        end,
        mode = { "n", "x" },
        expr = true,
      },
    },
  },
  "haya14busa/vim-asterisk",
}
