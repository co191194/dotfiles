require("auto-session").setup {
  log_level = "error",

  cwd_change_handling = {
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
  },

}

