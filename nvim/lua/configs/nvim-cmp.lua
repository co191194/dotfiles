local lspkind = require("lspkind")
local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local toggle_complete = function(_)
  if cmp.visible() then
    cmp.abort()
  else
    cmp.complete()
  end
end

---close menu and docs
---@param fallback function
local close_complete = function(fallback)
  local visible = cmp.visible()
  local visible_docs = cmp.visible_docs()
  if visible then
    cmp.abort()
  end
  if visible_docs then
    cmp.close_docs()
  end
  if not visible and not visible_docs then
    fallback()
  end
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<UP>"] = cmp.mapping.select_prev_item(),
    ["<DOWN>"] = cmp.mapping.select_next_item(),
    ["<C-space>"] = cmp.mapping.complete(),
    -- ["<C-l>"] = cmp.mapping.complete(),
    ["<C-l>"] = cmp.mapping(toggle_complete, { "i" }),
    -- ["<C-e>"] = cmp.mapping.abort(),
    ["<C-e>"] = cmp.mapping(close_complete, { "i", "s", "x", "n" }),
    -- ["<Esc>"] = cmp.mapping.abort(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  }),
  experimental = {
    ghost_text = false,
  },
  -- icon setting for lspkind
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = "...",
    }),
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    {
      name = "cmdline",
      option = {
        ignore_cmds = { "Man", "!", "r!", "read!" },
      },
    },
  }),
})
