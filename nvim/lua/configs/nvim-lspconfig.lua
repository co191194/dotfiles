-- 補完プラグインであるcmp_nvim_lspをLSPと連携させています（後述）
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

-- この一連の記述で、mason.nvimでインストールしたLanguage Serverが自動的に個別にセットアップされ、利用可能になります
require("neodev").setup()
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "lua_ls",
    "jdtls",
    "ruff_lsp",
    "rust_analyzer",
  },
})
local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
  -- default handler (optional)
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = capabilities, --cmpを連携
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
  ["jdtls"] = function()
    local my_jdtls_group = vim.api.nvim_create_augroup("MyJdtlsGroup", {})
    vim.api.nvim_create_autocmd({ "FileType" }, {
      group = my_jdtls_group,
      pattern = { "java" },
      callback = function()
        -- jdtls.start_or_attach(config,{},{})
        require("jdtls.jdtls_setup").setup()
      end,
    })
  end,
  ["rust_analyzer"] = function()
    lspconfig.rust_analyzer.setup({
      settings = {
        ["rust-analyzer"] = {
          diagnostic = { enable = false },
          assist = { importGranularity = "module", importPrefix = "self" },
          cargo = { allFeatures = true, loadOutDirsFromCheck = true },
          procMacro = { enable = true },
        },
      },
    })
  end,
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
})

local null_ls = require("null-ls")
null_ls.setup()
require("mason-null-ls").setup({
  ensure_installed = {
    "stylua",
    "selene",
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
  },
})

require("lspsaga").setup({
  lightbulb = {
    virtual_text = false,
  },
  finder = {
    max_height = 0.6,
    default = "tyd+ref+imp+def",
    keys = {
      toggle_or_open = "<CR>",
      vsplit = "v",
      split = "s",
      tabnew = "t",
      tab = "T",
      quit = "q",
      close = "<Esc>",
    },
    methods = {
      tyd = "textDocument/typeDefinition",
    },
  },
})

local map = vim.keymap.set
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map("n", "<space>e", vim.diagnostic.open_float)
map("n", "<space>q", vim.diagnostic.setloclist)
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
-- map("n", "<M-d>", "<cmd>Lspsaga term_toggle<CR>")
-- map("t", "<M-d>", "<C-\\><C-n><cmd>Lspsaga term_toggle<CR>")
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
    local opts = { buffer = ev.buf }
    -- map("n", "gD", vim.lsp.buf.declaration, opts)
    -- map("n", "gd", vim.lsp.buf.definition, opts)
    -- map("n", "K", vim.lsp.buf.hover, opts)
    -- map("n", "gi", vim.lsp.buf.implementation, opts)
    -- map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    -- map("n", "<space>rn", vim.lsp.buf.rename, opts)
    -- map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    -- map("n", "gr", vim.lsp.buf.references, opts)

    map("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
    map("n", "gD", "<cmd>Lspsaga peek_definition<CR>")
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>")
    map("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    map("n", "<space>rn", "<cmd>Lspsaga rename<CR>")
    map({ "n", "v" }, "<space>ca", "<cmd>Lspsaga code_action<CR>")
    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    map("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>")
    map("n", "<space>f", function()
      vim.lsp.buf.format({
        timeout_ms = 200,
        async = true,
      })
    end, opts)
    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    map("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    map("n", "<space>D", vim.lsp.buf.type_definition, opts)
    map("n", "<space>o", "<cmd>Lspsaga outline<CR>", {})
  end,
})
