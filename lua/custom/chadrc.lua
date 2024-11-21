--@type ChadrcConfig
local M = {}





-- Set the theme dynamically
M.ui = {
  theme = "catppuccin",
  theme_toggle = { "catppuccin" },
  statusline = {
    path_enabled = true,
  }
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
-- Set relative line numbering
vim.opt.relativenumber = true
vim.opt.number = true


return M
