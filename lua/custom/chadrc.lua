--@type ChadrcConfig
local M = {}

-- v3.0: theme config moved to base46
M.base46 = {
  theme = "runpuccin",
  theme_toggle = { "runpuccin" },
  transparency = true,
  hl_override = {
    -- make strings italic
    ["@string"] = {
      italic = true
    },
    -- make types italic
    ["@type"] = {
      italic = true
    },
    ["@type.builtin"] = {
      italic = true
    },
    -- make function names bold
    ["@function"] = {
      bold = true
    },
    ["@function.builtin"] = {
      bold = true,
    },
    -- make function calls bold and italic
    ["@function.call"] = {
      bold = true,
      italic = true
    },
    -- make method calls bold and italic
    ["@method.call"] = {
      bold = true,
      italic = true
    },
    -- make parameter types italic
    ["@parameter.type"] = {
      italic = true
    },
    -- make return types italic
    ["@type.return"] = {
      italic = true
    },
    TelescopeSelection = {
      bg = "#ff4da6",
      fg = "#f2f3f7"
    },
    -- Make tabline visible even with transparency enabled
    TbBufOn = {
      fg = "#f2f3f7",
      bg = "#24214d",
    },
    TbBufOff = {
      fg = "#7984D1",
      bg = "#1c1940",
    },
    TbFill = {
      bg = "#0c0a20",
    },
    TbBufOnClose = {
      fg = "#ff4da6",
      bg = "#24214d",
    },
    TbBufOffClose = {
      fg = "#7984D1",
      bg = "#1c1940",
    },
    TbBufOnModified = {
      fg = "#42c6ff",
      bg = "#24214d",
    },
    TbBufOffModified = {
      fg = "#ff4da6",
      bg = "#1c1940",
    },
  }
}

-- v3.0: UI-specific config (non-theme settings)
M.ui = {
  statusline = {
    path_enabled = true,  -- Your original setting
  },
  telescope = {
    style = "bordered",  -- Your original setting
  },
  tabufline = {
    enabled = true,
    lazyload = false,  -- Show tabs immediately on startup
  },
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

-- Set relative line numbering
vim.opt.relativenumber = true
vim.opt.number = true

-- indentation settings
vim.opt.expandtab = true   -- convert tabs to spaces
vim.opt.shiftwidth = 2     -- number of spaces for indentation
vim.opt.tabstop = 2        -- number of visual spaces per tab
vim.opt.softtabstop = 2    -- number of spaces inserted when using tab
vim.opt.smartindent = true -- enable smart indentation

-- ensure consistent indentation for specific file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "html", "css", "lua" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})


return M
