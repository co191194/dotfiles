require("CopilotChat").setup({
  window = {
    layout = "float",
    relative = "cursor",
    width = 1,
    height = 0.4,
    row = 1,
  },
})

local wk = require("which-key")
local prefix = "<leader>cc"

wk.add({
  { "<leader>c", group = "Copilot", noremap = false },
  { prefix, group = "Copilot Chat", noremap = false },
  { prefix .. "t", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Chat" },
  -- Quick chat keybinding
  {
    prefix .. "q",
    function()
      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        require("CopilotChat").ask(input, {
          selection = require("CopilotChat.select").buffer,
        })
      end
    end,
    desc = "Quick Chat",
  },
  {
    prefix .. "p",
    function()
      local chat = require("CopilotChat")
      chat.select_prompt()
    end,
    desc = "Select Prompt",
  },
})
