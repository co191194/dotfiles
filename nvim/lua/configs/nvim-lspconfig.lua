local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

require("neodev").setup()
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "lua_ls",
    "jdtls",
    "ruff_lsp",
    "rust_analyzer",
    "html",
    "emmet_ls",
    "volar",
    "tailwindcss",
    "tsserver",
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
  ["ruff_lsp"] = function()
    lspconfig.ruff_lsp.setup({
      init_options = {
        settings = {
          -- Any extra CLI arguments for `ruff` go here.
          args = {},
        },
      },
    })
  end,
  ["tsserver"] = function() end,
  ["volar"] = function()
    local util = require("lspconfig.util")
    local function get_ts_server_path(root_dir)
      local global_ts = require("mason-registry").get_package("vue-language-server"):get_install_path()
        .. "/node_modules/typescript/lib"
      local local_ts = ""
      local function check_dir(path)
        local_ts = util.path.join(path, "node_modules", "typescript", "lib")
        if util.path.exists(local_ts) then
          return path
        end
      end

      if util.search_ancestors(root_dir, check_dir) then
        return local_ts
      else
        return global_ts
      end
    end
    lspconfig.volar.setup({
      on_new_config = function(new_config, new_root_dir)
        new_config.init_options.typescript.tsdk = get_ts_server_path(new_root_dir)
      end,
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
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = require("mason-registry").get_package("vue-language-server"):get_install_path()
          .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
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
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map("n", "<space>e", vim.diagnostic.open_float)
map("n", "<space>q", vim.diagnostic.setloclist)
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
map("n", "<space>,", "<cmd>Lspsaga finder<CR>", {})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- local opts = { buffer = ev.buf }
    ---default opts func
    ---@param desc string
    ---@param options table
    ---@return table
    local function opts(desc, options)
      local o = options
      o.desc = "lsp: " .. desc
      return o
    end
    local function opts1(desc)
      return opts(desc, {})
    end
    local function opts2(desc)
      return opts(desc, { buffer = ev.buf })
    end

    map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts1("goto definition"))
    map("n", "gD", "<cmd>Lspsaga peek_definition<CR>", opts1("peek definition"))
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts1("hover doc"))
    map("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts1("signature help"))
    map("n", "<space>rn", "<cmd>Lspsaga rename<CR>", opts1("rename"))
    map({ "n", "v" }, "<space>ca", "<cmd>Lspsaga code_action<CR>", opts1("code action"))
    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts1("references"))
    map("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>", opts1("show line diagnostics"))
    -- map("n", "<space>f", function()
    --   vim.lsp.buf.format({
    --     timeout_ms = 500,
    --     async = true,
    --     bufnr = vim.api.nvim_get_current_buf(),
    --   })
    -- end, opts2("format"))
    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts2("add workspace folder"))
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts2("remove workspace folder"))
    map("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts2("list workspace folders"))
    map("n", "<space>D", vim.lsp.buf.type_definition, opts2("type type definition"))
    map("n", "<space>o", "<cmd>Lspsaga outline<CR>", opts1("outline"))
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

-- rustaceanvim
vim.g.rustaceanvim = {
  server = {
    cmd = function()
      local mason_registry = require("mason-registry")
      local ra_bin = mason_registry.is_installed("rust-analyzer")
          and vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
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
  },
  capabilities = capabilities,
}
