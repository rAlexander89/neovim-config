local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local opts = {
    sources = { null_ls.builtins.formatting.gofumpt.with({
        extra_args = { "-s" }, -- gofumpt specific argument to prevent new lines
    }),
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.golines.with({
            extra_args = { "--max-len=300" }
        }),
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "html", "css", "json", "yaml", "markdown", "javascript", "javascriptreact", "typescript", "typescriptreact" },
            extra_args = {
                "--tab-width", "4",
                "--print-width", "120",
                "--single-quote", "true",
                "--trailing-comma", "es5"
            }
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint.with({
            diagnostics_format = "[eslint] #{m}\n(#{c})",
            filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact"
            },
        }),
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
                group = augroup,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
}
return opts
