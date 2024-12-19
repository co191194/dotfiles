local hop = require("hop")
local hop_hint = require("hop.hint")

local wk = require("which-key")

local directions = hop_hint.HintDirection

hop.setup({})

wk.add({
  {
    "f",
    function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end,
  },
  {
    "F",
    function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end,
  },
  {
    "t",
    function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    end,
  },
  {
    "T",
    function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1})
    end,
  },
})
