local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

-- Define your own on_attach function if needed
local function custom_on_attach(client, bufnr)
  on_attach(client, bufnr) -- Call the existing on_attach function
  -- Add key mapping for code actions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fs',
    '<cmd>lua vim.lsp.buf.code_action({ source = { organizeImports = true } })<CR>',
    { noremap = true, silent = true }) -- Keybinding for fillstruct


  -- Add key mapping for hover information
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
    '<cmd>lua vim.lsp.buf.hover()<CR>',
    { noremap = true, silent = true }) -- Keybinding for hover (shows information about variable, method, etc.)
end

lspconfig.ts_ls.setup({ -- tsserver is deprecated? use ts_ls
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- format on save for js/ts files
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            async = false,
            timeout_ms = 3000,
            -- ensure 2 space indentation
            formatting_options = {
              tabSize = 2,
              insertSpaces = true
            }
          })
        end,
      })
    end
  end,
  capabilities = capabilities,
  settings = {
    javascript = {
      format = {
        indentSize = 2,
        tabSize = 2,
        insertSpaces = true
      },
      suggest = {
        completeFunctionCalls = true,
        includeCompletionsForImportStatements = true,
        enabled = true
      },
      validate = {
        enabled = true
      },
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    typescript = { -- add typescript settings for .tsx files
      format = {
        indentSize = 2,
        tabSize = 2,
        insertSpaces = true
      },
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    completions = {
      completeFunctionCalls = true,
    },
  },
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "non-relative",
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      includeCompletionsWithSnippetText = true,
      includeAutomaticOptionalChainCompletions = true,
      moduleResolutionPreference = "esm" -- This enforces ES modules

    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact"
  },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
})


lspconfig.eslint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact"
  },
  root_dir = lspconfig.util.root_pattern(
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.json",
    ".eslintrc.cjs", -- added common config patterns
    ".eslintrc.yaml",
    ".eslintrc.yml",
    "package.json"
  ),
})


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
  },
}


-- local servers = { 'ccls', 'cmake', 'tsserver', 'templ' }
local servers = { 'ccls', 'cmake', 'templ', 'cssls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

lspconfig.html.setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- Enable format on save
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
  capabilities = capabilities,
  filetypes = { "html", "templ", "htmx" },
})


--  lspconfig.htmx.setup({
--    filetypes = { "html", "templ" },
--  })


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
