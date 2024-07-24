local treesj = require("treesj")
treesj.setup({})

local wk = require("which-key")
wk.add({
  { "<space>m", treesj.toggle, desc = "treesj: Toggle Split/Join Code Block" },
  { "<space>j", treesj.join, desc = "treesj: Join Code Block" },
  { "<space>s", treesj.split, desc = "treesj: Split Code Block" },
})
