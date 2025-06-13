local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "lua_ls",
    "jdtls",
    "ruff",
    "rust_analyzer",
    "html",
    "emmet_ls",
    "vue_ls",
    "tailwindcss",
    "ts_ls",
    "cssls",
    "yamlls",
    "jsonls",
    "gopls",
  },
  automatic_enable = {
    exclude = {
      "rust_analyzer",
      "gopls",
      -- "jdtls",
    },
  },
})

-- lua
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        global = { "vim" },
      },
    },
  },
})

-- java
vim.lsp.config("jdtls", {
  on_attach = require("configs.nvim-java").on_attach,
})
require("configs.nvim-java").keymap()
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   group = vim.api.nvim_create_augroup("MyJavaSetup", {}),
--   pattern = "java",
--   callback = function()
--     require("java").setup()
--   end,
--   once = true,
-- })

-- python
vim.lsp.config("pyright", {
  settings = {
    pyright = {
      -- using Ruff's import organaizer
      disableOrgnizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { "*" },
      },
    },
  },
})

-- ts
local home = vim.fn.expand("$HOME")
local vue_typescript_plugin = home
  .. "/.volta/tools/image/packages/@vue/typescript-plugin/lib/node_modules/@vue/typescript-plugin"
vim.lsp.config("ts_ls", {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_typescript_plugin,
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "vue",
  },
})

-- json
vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

-- yaml
vim.lsp.config("yamlls", {
  settings = {
    schemaStore = {
      enable = false,
      url = "",
    },
    schemas = require("schemastore").yaml.schemas(),
  },
})

-- markdown
vim.lsp.config("markdown_oxide", {
  capabilities = capabilities,
})
vim.lsp.enable("markdown_oxide")

local null_ls = require("null-ls")
require("mason-null-ls").setup({
  ensure_installed = {
    "stylua",
    "selene",
    "prettier",
    "prettierd",
  },
  automatic_installation = false,
  ignore_methods = {
    diagnostics = false,
    formatting = false,
    hover = false,
    completion = false,
    code_actions = false,
  },
  handlers = {
    function() end,
    stylua = function(source_name, methods)
      null_ls.register(null_ls.builtins.formatting.stylua)
    end,
    selene = function(source_name, methods)
      null_ls.register(null_ls.builtins.diagnostics.selene)
    end,
    prettier = function(source_name, methods)
      null_ls.register(null_ls.builtins.formatting.prettier.with({
        extra_filetypes = { "toml" },
      }))
    end,
  },
})
local lsp_format = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      local list = { "null-ls", "rust-analyzer", "ruff" }
      for _, m in ipairs(list) do
        if m == client.name then
          return true
        end
      end
      return false
    end,
    bufnr = bufnr,
  })
end

local function on_attach_format(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.keymap.set("n", "<space>f", function()
      lsp_format(bufnr)
    end, { buffer = bufnr, desc = "lsp: Format" })
  end
  if client.supports_method("textDocument/rangeFormatting") then
    vim.keymap.set("x", "<space>f", function()
      vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
    end, { buffer = bufnr, desc = "lsp: Format" })
  end
end

null_ls.setup({
  on_attach = on_attach_format,
  sources = {},
})

-- ruff
vim.lsp.config("ruff", {
  settings = {},
  on_attach = on_attach_format,
})

local map = vim.keymap.set
local wk = require("which-key")
-- Global mappings.
wk.add({
  { "<space>e", vim.diagnostic.open_float, desc = "LSP: Open Float Diagnostic" },
  { "<space>q", vim.diagnostic.setloclist, desc = "LSP: Set Loclist" },
  { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "LSP: Next Diagnostic" },
  { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "LSP: Prev Diagnostic" },
  { "<space>,", "<cmd>Lspsaga finder<CR>", desc = "LSP: Open LspSaga Finder" },
})

local is_mapped_lsp = false
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    if is_mapped_lsp then
      return
    end
    is_mapped_lsp = true
    wk.add({
      { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "LSP: goto definition" },
      { "gD", "<cmd>Lspsaga peek_definition<CR>", desc = "LSP: peek definition" },
      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "LSP: hover doc" },
      { "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "LSP: signature help" },
      { "<space>r", group = "LSP: rename" },
      { "<space>rn", "<cmd>Lspsaga rename<CR>", desc = "LSP: rename" },
      { "<space>c", group = "LSP: Code Action" },
      { "<space>ca", "<cmd>Lspsaga code_action<CR>", desc = "LSP: code action", mode = "nv" },
      { "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "LSP: references" },
      { "ge", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "LSP: show line diagnostics" },
      { "<space>o", "<cmd>Lspsaga outline<CR>", desc = "LSP: outline" },
      {
        buffer = ev.buf,
        { "<space>w", group = "LSP: workspace" },
        { "<space>wa", vim.lsp.buf.add_workspace_folder, desc = "LSP: add workspace folder" },
        { "<space>wr", vim.lsp.buf.remove_workspace_folder, desc = "LSP: remove workspace folder" },
        {
          "<space>wl",
          function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end,
          desc = "LSP: list workspace folders",
        },
        { "<space>D", vim.lsp.buf.type_definition, desc = "LSP: type definition" },
      },
    })
  end,
})

-- custom filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "yaml",
  group = vim.api.nvim_create_augroup("yamlDetect", {}),
  callback = function()
    local current = vim.fn.expand("%:t:r")
    if current == "docker-compose" or current == "compose" then
      vim.opt.filetype = "yaml.docker-compose"
    end
  end,
})

-- dap settings
require("mason-nvim-dap").setup({
  ensure_installed = { "python", "js", "chrome", "javadbg", "javatest" },
  automatic_installation = false,
  handlers = {
    function(config)
      require("mason-nvim-dap").default_setup(config)
    end,
    python = function(config)
      config.adapters = {
        type = "executable",
        command = "/usr/bin/python3",
        args = {
          "-m",
          "debugpy.adapter",
        },
        require("mason-nvim-dap").default_setup(config),
      }
    end,
    javadbg = nil,
    javatest = nil,
  },
})

-- dap keymaps
local dap_opts = function(desc)
  return { desc = "nvim-dap : " .. desc, silent = true }
end
local dap = require("dap")
map("n", "<F5>", dap.continue, dap_opts("Continue"))
map("n", "<F10>", dap.step_over, dap_opts("StepOver"))
map("n", "<F11>", dap.step_into, dap_opts("StepIn"))
map("n", "<F12>", dap.step_out, dap_opts("StepOut"))
map("n", "<leader>b", dap.toggle_breakpoint, dap_opts("Toggle Breakpoint"))
map("n", "<leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "), nil, nil)
end, dap_opts("Set Condition Breakpoint"))
map("n", "<leader>lp", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, dap_opts("Set breakpoint and log message"))
map("n", "<leader>dr", dap.repl.open, dap_opts("Open a REPL / Debug-console"))
map("n", "<leader>dl", dap.run_last, dap_opts("Re-runs the last debug adapter"))

-- dapui setup
local dapui = require("dapui")
local dapui_config = require("dapui.config")
dapui_config.layouts = {
  {
    elements = {
      { id = "watches", size = 0.20 },
      { id = "stacks", size = 0.20 },
      { id = "breakpoints", size = 0.20 },
      { id = "scopes", size = 0.40 },
    },
    size = 64,
    position = "right",
  },
  {
    elements = {
      "repl",
      "console",
    },
    size = 0.20,
    position = "bottom",
  },
}
dapui.setup(dapui_config)

-- dapui keymap
local dapui_opts = function(desc)
  return { desc = "dap-ui: " .. desc }
end
map("n", "<space>d", function()
  dapui.toggle()
end, dapui_opts("Toggle"))

local mason_registry = require("mason-registry")
---get binary path install by mason
---@param lsp_name string
---@param bin_name string
---@return string
local function get_mason_lsp_bin_path(lsp_name, bin_name)
  local is_win32 = vim.fn.has("win32") == 1
  if is_win32 then
    return mason_registry.get_package(lsp_name):get_install_path() .. "/" .. bin_name
  else
    return vim.fn.stdpath("data") .. "/mason/bin/" .. bin_name
  end
end

-- rustaceanvim
vim.g.rustaceanvim = {
  server = {
    cmd = function()
      local lsp_name = "rust-analyzer"
      local ra_bin = mason_registry.is_installed(lsp_name) and get_mason_lsp_bin_path(lsp_name, lsp_name)
        or "rust-analyzer"
      return { ra_bin }
    end,
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.keymap.set("n", "<space>f", function()
          lsp_format(bufnr)
        end, { buffer = bufnr, desc = "lsp: Format" })
      end
      if client.supports_method("textDocument/rangeFormatting") then
        vim.keymap.set("x", "<space>f", function()
          lsp_format(bufnr)
        end, { buffer = bufnr, desc = "lsp: Format" })
      end
    end,
    capabilities = capabilities,
  },
}
