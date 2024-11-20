local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

-- Define your own on_attach function if needed
local function custom_on_attach(client, bufnr)
  on_attach(client, bufnr) -- Call the existing on_attach function
  -- Add key mapping for code actions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fs',
    '<cmd>lua vim.lsp.buf.code_action({ source = { organizeImports = true } })<CR>', { noremap = true, silent = true }) -- Keybinding for fillstruct


  -- Add key mapping for hover information
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
    '<cmd>lua vim.lsp.buf.hover()<CR>',
    { noremap = true, silent = true }) -- Keybinding for hover (shows information about variable, method, etc.)
end


lspconfig.gopls.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = false,
      analyses = {
        unusedparams = true,
        fillstruct = true,
      },
    },
  }, fzr
}


-- local servers = { 'ccls', 'cmake', 'tsserver', 'templ' }
local servers = { 'ccls', 'cmake','templ' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "vscode-html-language-server", "--stdio" }, -- Ensure correct cmd is specified
  filetypes = { "html", "templ", "htmx" },            -- Added htmx to filetypes
})

--  lspconfig.htmx.setup({
--    filetypes = { "html", "templ" },
--  })


-- TailwindCSS language server setup
-- lspconfig.tailwindcss.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = { "html", "templ", "astro", "javascript", "typescript", "javascriptreact", "typescriptreact" }, -- Added correct filetypes
--   init_options = { userLanguages = { templ = "html" } },                                                      -- Optional: map templ files to HTML for TailwindCSS
--   settings = {                                                                                                -- Add any TailwindCSS-specific settings here if needed
--     tailwindCSS = {
--       experimental = {
--         classRegex = {
--           { "class\\s*[:=]\\s*['\"]([^'\"]*)['\"]", 1 },
--           { "class\\s*[:=]\\s*['\"]([^'\"]*)['\"]", 1 },
--           { "tw\\`([^`]*)\\`",                      1 },
--         },
--       },
--     },
--   },
-- })

-- TypeScript language server setup
-- lspconfig.tsserver.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   cmd = { "typescript-language-server", "--stdio" },
--   init_options = {
--     logVerbosity = "verbose",
--     logFile = vim.fn.expand("~/.local/share/nvim/tsserver.log")
--   }
-- })
-- Setup lua_ls
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
lspconfig.lua_ls.setup {
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
  settings = {
    Lua = {
      format = {
        enable = true,
      },
    },
  },
}
