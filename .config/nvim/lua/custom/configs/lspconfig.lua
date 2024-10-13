local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")
local servers = {"html", "cssls", "clangd"}

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
}

-- Set up LSP servers in a loop
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Update tsserver to ts_ls
lspconfig.ts_ls.setup {  -- Change here from tsserver to ts_ls
  on_attach = on_attach,
  capabilities = capabilities,
  -- init_options = {
  -- preferences = {
  -- disableSuggestions = true,
  -- }
  -- }
}

