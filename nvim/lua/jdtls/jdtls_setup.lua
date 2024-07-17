local M = {}
local mason_registry = require("mason-registry")
local path_to_jdtls = mason_registry.get_package("jdtls"):get_install_path()
local path_to_jdebug = mason_registry.get_package("java-debug-adapter"):get_install_path()
local path_to_jtest = mason_registry.get_package("java-test"):get_install_path()
local jdtls = require("jdtls")
local jdtls_dap = require("jdtls.dap")
local jdtls_setup = require("jdtls.setup")

local function get_config_dir()
  if vim.fn.has("linux") == 1 then
    return "config_linux"
  elseif vim.fn.has("mac") == 1 then
    return "config_mac"
  else
    return "config_win"
  end
end

local function get_path_to_jar()
  local findFiles = vim.fs.find(
    ---@param name string
    ---@param _ string
    function(name, _)
      return name:match("org.eclipse.equinox.launcher_.*.v.*.jar")
    end,
    { type = "file", path = path_to_jdtls .. "/plugins" }
  )
  return findFiles[1]
end

local path_to_config = path_to_jdtls .. "/" .. get_config_dir()
local lombok_path = path_to_jdtls .. "/lombok.jar"
local path_to_jar = get_path_to_jar()
local bundles = {
  vim.fn.glob(path_to_jdebug .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(path_to_jtest .. "/extension/server/*.jar", true), "\n"))

local on_attach = function(_, bufnr)
  jdtls.setup_dap({ hotcodereplace = "auto" })
  jdtls_dap.setup_dap_main_class_configs()
  -- jdtls_setup.add_commands()

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })

  require("lsp_signature").on_attach({
    bind = true,
    padding = "",
    handler_opts = {
      border = "rounded",
    },
    hint_prefix = "󱄑 ",
  }, bufnr)

  -- NOTE: comment out if you don't use Lspsaga
  -- require("lspsaga").init_lsp_saga()
end

local capabilities = {
  workspace = {
    configuration = true,
  },
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
      },
    },
  },
}
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local settings = {
  java = {
    references = {
      includeDecompiledSources = true,
    },
    format = {
      enabled = true,
      settings = {
        url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
        profile = "GoogleStyle",
      },
    },
    eclipse = {
      downloadSources = true,
    },
    maven = {
      downloadSources = true,
    },
    signatureHelp = { enabled = true },
    contentProvider = { preferred = "fernflower" },
    -- eclipse = {
    -- 	downloadSources = true,
    -- },
    -- implementationsCodeLens = {
    -- 	enabled = true,
    -- },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      filteredTypes = {
        "com.sun.*",
        "io.micrometer.shaded.*",
        "java.awt.*",
        "jdk.*",
        "sun.*",
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org",
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        -- flags = {
        -- 	allow_incremental_sync = true,
        -- },
      },
      useBlocks = true,
    },
    -- configuration = {
    --     runtimes = {
    --         {
    --             name = "java-17-openjdk",
    --             path = "/usr/lib/jvm/default-runtime/bin/java"
    --         }
    --     }
    -- }
    -- project = {
    -- 	referencedLibraries = {
    -- 		"**/lib/*.jar",
    -- 	},
    -- },
  },
}
local on_init = function(client, _)
  client.notify("workspace/didChangeConfiguration", { settings = settings })
end

vim.api.nvim_create_user_command("TestFind", function()
  print("Hi jdtls")
  print(path_to_jdtls)
  print(get_path_to_jar())
  print(path_to_jdebug)
  print(path_to_jtest)
end, {})

function M.setup()
  local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
  local root_dir = jdtls_setup.find_root(root_markers)

  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

  -- LSP settings for Java.

  local config = {
    flags = {
      allow_incremental_sync = true,
    },
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extendedClientCapabilities,
    },
    settings = settings,
    on_init = on_init,
    cmd = {
      --
      -- 				-- 💀
      "java", -- or '/path/to/java17_or_newer/bin/java'
      -- depends on if `java` is in your $PATH env variable and if it points to the right version.

      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "-javaagent:" .. lombok_path,
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",

      -- 💀
      "-jar",
      path_to_jar,
      -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
      -- Must point to the                                                     Change this to
      -- eclipse.jdt.ls installation                                           the actual version

      -- 💀
      "-configuration",
      path_to_config,
      -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
      -- Must point to the                      Change to one of `linux`, `win` or `mac`
      -- eclipse.jdt.ls installation            Depending on your system.

      -- 💀
      -- See `data directory configuration` section in the README
      "-data",
      workspace_dir,
    },
  }

  -- Start Server
  jdtls.start_or_attach(config)

  -- Set Java Specific Keymaps
  require("jdtls.keymaps")
end

return M
