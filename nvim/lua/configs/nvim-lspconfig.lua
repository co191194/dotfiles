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
    "volar",
    "tailwindcss",
    "ts_ls",
    "cssls",
    "yamlls",
    "jsonls",
  },
})
local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
  -- default handler (optional)
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = capabilities,
    })
  end,
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
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
  end,
  ["jdtls"] = function() end,
  ["rust_analyzer"] = function() end,
  ["pyright"] = function()
    require("lspconfig").pyright.setup({
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
  end,
  -- ["ruff_lsp"] = function()
  --   lspconfig.ruff_lsp.setup({
  --     init_options = {
  --       settings = {
  --         -- Any extra CLI arguments for `ruff` go here.
  --         args = {},
  --       },
  --     },
  --   })
  -- end,
  ["ts_ls"] = function() end,
  -- ["ts_ls"] = function()
  --   local home = vim.fn.system({ "echo", "$HOME" })
  --   lspconfig.ts_ls.setup({
  --     init_options = {
  --       plugins = {
  --         {
  --           name = "@vue/typescript-plugin",
  --           location = home
  --             .. ".volta/tools/image/packages/@vue/language-server/lib/node_modules/@vue/typescript-plugin",
  --           languages = { "javascript", "typescript", "vue" },
  --         },
  --       },
  --     },
  --     filetypes = {
  --       "javascript",
  --       "javascriptreact",
  --       "javascript.jsx",
  --       "typescript",
  --       "typescriptreact",
  --       "typescript.tsx",
  --       "vue",
  --     },
  --   })
  -- end,
  ["volar"] = function()
    lspconfig.volar.setup({
      filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "json",
      },
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })
  end,
  ["jsonls"] = function()
    lspconfig.jsonls.setup({
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })
  end,
  ["yamlls"] = function()
    lspconfig.yamlls.setup({
      settings = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("MyJdtls", { clear = true }),
  pattern = { "java" },
  callback = function(ev)
    require("jdtls.jdtls_setup").setup()
  end,
})
-- typescript-tools setup
require("typescript-tools").setup({
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    separate_diagnostic_server = true,
    publish_diagnostic_on = "insert_leave",
    expose_as_code_action = {},
    ts_ls_path = nil,
    ts_ls_plugins = {
      "@vue/typescript-plugin",
    },
    ts_ls_max_memory = "auto",
    ts_ls_format_options = {},
    ts_ls_file_preferences = {},
    ts_ls_locale = "en",
    complete_function_calls = false,
    include_completions_with_insert_text = true,
    code_lens = "off",
    disable_member_code_lens = true,
    jsx_close_tag = {
      enable = false,
      filetypes = { "javascriptreact", "typescriptreact" },
    },
  },
})

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
    -- prettierd = function(source_name, methods)
    --   null_ls.register(null_ls.builtins.formatting.prettierd.with({
    --     extra_filetypes = { "toml" },
    --   }))
    -- end,
  },
})
local lsp_format = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls" or "rust-analyzer"
    end,
    bufnr = bufnr,
  })
end
null_ls.setup({
  on_attach = function(client, bufnr)
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
  end,
  sources = {},
})

-- local prettier = require("prettier")
--
-- prettier.setup({
--   bin = "prettierd",
--   filetypes = {
--     "css",
--     "graphql",
--     "html",
--     "javascript",
--     "javascriptreact",
--     "json",
--     "less",
--     "markdown",
--     "scss",
--     "typescript",
--     "typescriptreact",
--     "yaml",
--   },
--   ["null-ls"] = {
--     condition = function()
--       return prettier.config_exists({
--         -- if `false`, skips checking `package.json` for `"prettier"` key
--         check_package_json = true,
--       })
--     end,
--     runtime_condition = function(params)
--       -- return false to skip running prettier
--       return true
--     end,
--     timeout = 5000,
--   },
-- })

local map = vim.keymap.set
local wk = require("which-key")
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- map("n", "<space>e", vim.diagnostic.open_float)
-- map("n", "<space>q", vim.diagnostic.setloclist)
-- map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
-- map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
-- map("n", "<space>,", "<cmd>Lspsaga finder<CR>", {})
wk.add({
  { "<space>e", vim.diagnostic.open_float, desc = "LSP: Open Float Diagnostic" },
  { "<space>q", vim.diagnostic.setloclist, desc = "LSP: Set Loclist" },
  { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "LSP: Next Diagnostic" },
  { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "LSP: Prev Diagnostic" },
  { "<space>,", "<cmd>Lspsaga finder<CR>", desc = "LSP: Open LspSaga Finder" },
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

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
    capabilities = capabilities
  },
}
