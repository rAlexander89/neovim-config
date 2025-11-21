-- Custom initialization file

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
