vim.opt.termguicolors = true
local bufferline = require("bufferline")
bufferline.setup({
  options = {
    diagnostics = "nvim_lsp",
    --- count is an integer representing total count of errors
    --- level is a string "error" | "warning"
    --- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
    --- this should return a string
    --- Don't get too fancy as this function will be executed a lot
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " " or (e == "warning" and " " or " ")
        s = s .. sym .. n
      end
      return s
    end,
    offsets = {
      {
        filetype = "sagaoutline",
        text = "Outline",
        text_align = "left",
        separator = true,
      },
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true,
      },
    },
  },
})

local function close_current_buf()
  local buf = vim.fn.bufnr()
  vim.cmd("bd " .. buf)
end

local prefix = "<space>b"
local prefix_desc = "BufferLine: "

---@param lsh string
---@param rsh string | function
---@param desc string
---@return table
local function map(lsh, rsh, desc)
  return { prefix .. lsh, rsh, desc = prefix_desc .. desc }
end

local wk = require("which-key")

wk.add({
  { prefix, group = "BufferLine" },
})

-- Buffer Close Key Map
prefix = "<space>bc"
wk.add({
  { prefix, group = "Buf Close" },
  map("l", "<cmd>BufferLineCloseLeft<cr>", "Close Left"),
  map("r", "<cmd>BufferLineCloseRight<cr>", "Close Right"),
  map("o", "<cmd>BufferLineCloseOthers<cr>", "Close Others"),
})

-- Buffer Line Operation Key Map
prefix = ""
wk.add({
  map("<M-,>", "<cmd>BufferLineCyclePrev<cr>", "Go Prev"),
  map("<M-.>", "<cmd>BufferLineCycleNext<cr>", "Go Next"),
  map("<M-<>", "<cmd>BufferLineMovePrev<cr>", "Move Prev "),
  map("<M->>", "<cmd>BufferLineMoveNext<cr>", "Move Next"),
  map("gb", "<cmd>BufferLinePick<cr>", "GoTo Buffer"),
  map("gB", "<cmd>BufferLinePickClose<cr>", "Close Pick"),
  map("<M-c>", close_current_buf, "Close Current"),
})
