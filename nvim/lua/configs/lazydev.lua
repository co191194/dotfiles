require("lazydev").setup({
  library = {
    { path = "luvit-meta/library", words = { "vim%.uv" } },
    { path = "LazyVim", words = { "LazyVim" } },
    { path = "wezterm-types", mods = { "wezterm" } },
  },
})
