dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

-- Temporarily suppress deprecation warnings while we use the old lspconfig API
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg:match("lspconfig.*deprecated") then
    return
  end
  notify(msg, level, opts)
end

local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })

  -- Note: nvchad.signature was removed in v3.0
  -- Signature help still works via LSP, just without the custom NvChad UI
end

-- disable semantic tokens
M.on_init = function(client, _)
  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- lua_ls is configured in custom/configs/lspconfig.lua to avoid duplicate setup

return M
