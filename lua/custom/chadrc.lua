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
    -- Statusline highlights
    St_NormalMode = {
      fg = "#0c0a20",
      bg = "#42c6ff",
      bold = true,
    },
    St_NormalModeSep = { fg = "#42c6ff", bg = "#24214d" },
    St_InsertMode = {
      fg = "#0c0a20",
      bg = "#ff4da6",
      bold = true,
    },
    St_InsertModeSep = { fg = "#ff4da6", bg = "#24214d" },
    St_VisualMode = {
      fg = "#0c0a20",
      bg = "#df85ff",
      bold = true,
    },
    St_VisualModeSep = { fg = "#df85ff", bg = "#24214d" },
    St_ReplaceMode = {
      fg = "#0c0a20",
      bg = "#ff9b50",
      bold = true,
    },
    St_ReplaceModeSep = { fg = "#ff9b50", bg = "#24214d" },
    St_CommandMode = {
      fg = "#0c0a20",
      bg = "#ffe566",
      bold = true,
    },
    St_CommandModeSep = { fg = "#ffe566", bg = "#24214d" },
    St_TerminalMode = {
      fg = "#0c0a20",
      bg = "#62dfff",
      bold = true,
    },
    St_TerminalModeSep = { fg = "#62dfff", bg = "NONE" },
    St_NTerminalModeSep = { fg = "#ffe566", bg = "NONE" },
    St_SelectModeSep = { fg = "#62dfff", bg = "NONE" },
    St_ConfirmModeSep = { fg = "#42c6ff", bg = "NONE" },
    StatusLine = {
      bg = "NONE",
    },
    St_EmptySpace = {
      bg = "NONE",
    },
    St_file = {
      fg = "#f2f3f7",
      bg = "NONE",
    },
    St_gitIcons = {
      fg = "#ff4da6",
      bg = "#1c1940",
      bold = true,
    },
    St_LspMsg = {
      fg = "#42c6ff",
      bg = "#131033",
    },
    St_LspStatus = {
      fg = "#42c6ff",
      bg = "#1c1940",
    },
    St_cwd = {
      fg = "#f2f3f7",
      bg = "#24214d",
    },
    St_pos = {
      fg = "#f2f3f7",
      bg = "#1c1940",
    },
    St_sep = {
      fg = "#24214d",
      bg = "#131033",
    },
    St_sep_r = {
      fg = "#24214d",
      bg = "#131033",
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

-- 4-space indentation for C/C++
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

-- ensure regular buffers are always modifiable
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local buftype = vim.bo.buftype
    -- only set modifiable for normal file buffers
    if buftype == "" then
      vim.opt_local.modifiable = true
    end
  end,
})


return M
