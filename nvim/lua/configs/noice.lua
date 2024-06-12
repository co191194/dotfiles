require("noice").setup({
  lsp = {
    signature = {
      enabled = false,
    },
  },
  notify = {
    enabled = true,
    view = "notify",
  },
  routes = {
    {
      filter = {
        event = "notify",
        find = "No information available",
      },
      opts = {
        skip = true,
      },
    },
  },
})
