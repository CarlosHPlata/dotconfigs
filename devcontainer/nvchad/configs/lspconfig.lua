require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

local servers = {
  "lua_ls",
  "ts_ls",
}

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }

  local clients = vim.lsp.get_clients { name = "ts_ls" }
  if #clients == 0 then
    vim.notify("No ts_ls client found", vim.log.levels.ERROR)
    return
  end
  local client = clients[1]
  client:exec_cmd(params)
  vim.notify("Imports sorted", vim.log.levels.INFO)
end

lspconfig.ts_ls.setup {
  init_options = {
    preferences = {
      -- other preferences
      importModuleSpecifier = "non-relative",
      importModuleSpecifierPreference = "non-relative",
    }
  },
  on_attach = function(client, bufnr)
    -- use default on_attach provided by nvchad
    nvlsp.on_attach(client, bufnr)

    -- Disable tsserver's formatting capabilities if using external formatters
    client.server_capabilities.documentFormattingProvider = false
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "OrganizeImports",
    })
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    -- Customize settings for tsserver if needed
    completions = {
      completeFunctionCalls = true,
    }
  },
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize imports in the current file"
    }
  }
}

vim.diagnostic.config {
  virtual_text = false,     -- show virtual text
  signs = true,             -- show signs in the linter gutter
  underline = true,         -- underline the text when errors
  update_in_insert = false, -- update the diagnostics in insert mode
  severity_sort = true,     -- sort the diagnostics by severity
}
vim.o.updatetime = 250      -- set the time it takes to show the diagnostics
vim.cmd [[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]]
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
