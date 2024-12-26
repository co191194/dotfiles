local lspkind = require("lspkind")
local cmp = require("cmp")
local luasnip = require("luasnip")

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
  sources = cmp.config.sources({
    { name = "lazydev" },
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "crates" },
    { name = "buffer", keyword_length = 3 },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<UP>"] = cmp.mapping.select_prev_item(),
    ["<DOWN>"] = cmp.mapping.select_next_item(),
    ["<C-space>"] = cmp.mapping(toggle_complete, { "i" }),
    -- ["<C-l>"] = cmp.mapping.complete(),
    ["<C-l>"] = cmp.mapping(toggle_complete, { "i" }),
    -- ["<C-e>"] = cmp.mapping.abort(),
    ["<C-e>"] = cmp.mapping(close_complete, { "i", "s", "x", "n" }),
    -- ["<Esc>"] = cmp.mapping.abort(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          cmp.select_next_item()
        end
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
          if luasnip.expandable() then
            luasnip.expand()
          else
            cmp.confirm({ select = false })
          end
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
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "...",
      before = function (entry, vim_item)
        vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
        return vim_item
      end
    }),
  },
  preselect = 'None'
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "buffer" },
  }),
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
