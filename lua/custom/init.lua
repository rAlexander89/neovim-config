-- Custom initialization file

-- Allow per-project .nvim.lua files to configure rust-analyzer scope
vim.o.exrc = true
vim.o.secure = true

-- Force terraform indentation settings on every buffer enter.
-- Belt-and-suspenders: after/indent and after/ftplugin both run first,
-- but treesitter's BufEnter autocmd can still override them.
-- vim.schedule defers to after all current callbacks so this always wins.
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.schedule(function()
      vim.bo.indentexpr = ""
      vim.opt_local.smartindent = true
    end)
  end,
})

-- Filetype detection for mermaid files
vim.filetype.add({
  extension = {
    mmd = "mermaid",
    mermaid = "mermaid",
  },
  pattern = {
    [".*%.mermaid%.md"] = "mermaid",
  },
})
