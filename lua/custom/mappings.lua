local M = {}


M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags",
    },
    ["<leader>gff"] = {
      ":lua require('gopher.plugin').generate_form_fields()<CR>",
      "Generate form fields",
    },
    ["<leader>gdb"] = {
      ":lua require('gopher.plugin').generate_db_sql_fields()<CR>",
      "Generate DB SQL fields",
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags",
    },
    ["C-l"] = { ":lua require('gopher.struct').fillstruct()<CR>", "Fill Struct" },
  },
}
M.dap = {
  plugin = true,
  n = {
    ["<leader>pp"] = {
      "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
      "Toggle Breakpoint",
    },
    ["<leader>dc"] = {
      "<cmd>lua require'dap'.continue()<CR>",
      "Continue Debugging",
    },
    ["<leader>dr"] = {
      "<cmd>lua require'dap'.restart()<CR>",
      "Restart Debugging"
    },
    ["<leader>ds"] = { -- Add this mapping
      "<cmd>lua require'dap'.run()<CR>",
      "Start Debugging"
    },
    ["<leader>dt"] = {
      "<cmd>lua require'dap'.terminate(); require'dapui'.close()<CR>",
      "Terminate Debugging"
    },
    ["<leader>dx"] = {
      function()
        print(vim.inspect(require('dap').configurations.go))
      end,
      "Inspect DAP Config"
    },
    ["<leader>pc"] = {
      "<cmd>lua require('dap').clear_breakpoints()<CR>",
      "Clear all breakpoints"
    },
  },
}
-- Function to toggle between relative and absolute line numbering
local function toggle_line_numbering()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = true
  else
    vim.wo.relativenumber = true
    vim.wo.number = true
  end
end

local function toggle_multiline_comment()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  vim.cmd ":'<,'>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())"
end



local function toggle_comment()
  require("Comment.api").toggle.linewise.current()
end

local function reload_theme()
  -- Clear highlight cache
  vim.cmd("lua package.loaded['custom.theme'] = nil")
  -- Reload base46 highlights
  require("base46").load_all_highlights()
  -- Optional: Print confirmation
  vim.notify("Theme reloaded!", vim.log.levels.INFO)
end



M.custom = {
  n = {
    ["<leader>tr"] = {
      reload_theme,
      "Reload  theme"
    },
    -- -- refresh themes!!!
    -- ["<leader>tr"] = {
    --   function()
    --     reload_theme()
    --   end,
    --   "Reload current theme"
    -- },
    -- For right pane
    ["<leader>p]"] = { "<C-w>l", "Move to right pane" },
    -- For left pane
    ["<leader>p["] = { "<C-w>h", "Move to left pane" },
    -- Ensure paste commands use the unnamed register
    ["p"] = { '"0p', "Paste from yank register" },
    ["P"] = { '"0P', "Paste from yank register" },
    ["<leader>ll"] = {
      toggle_line_numbering,
      "Toggle line numbering",
    },
    ["<leader>ld"] = { '"_dd', "Delete line without copying" },
    ["<leader>gf"] = {
      function()
        vim.cmd "tab split"
        vim.cmd "normal! gf"
      end,
      "Open file under cursor in new tab",
    },
    ["<C-]>"] = {
      function()
        vim.cmd "bnext"
      end,
      "Go to next buffer",
    },
    ["<C-[>"] = {
      function()
        vim.cmd "bprevious"
      end,
      "Go to previous buffer",
    },
    -- Delete previous word without yanking
    ["<M-BS>"] = { '"_db', "Delete previous word" },

    -- Delete forward word without yanking
    ["<M-d>"] = { '"_dw', "Delete FORward word" },
    ["<M-j>"] = {
      ":move .+1<CR>==",
      "Move line down",
    },
    ["<M-k>"] = {
      ":move .-2<CR>==",
      "Move line up",
    },
    ["<M-/>"] = {
      toggle_comment,
      "Toggle comment",
    },
    ["<leader>rsl"] = {
      function()
        vim.lsp.stop_client(vim.lsp.get_active_clients())
        vim.cmd("edit")
      end,
      "Restart LSP"
    },
    ["<leader>rsn"] = {
      function()
        vim.cmd('source ~/.config/nvim/init.lua')
        require('base46').load_all_highlights()
        vim.notify('Neovim config reloaded!', vim.log.levels.INFO)
      end,
      "Source/Reload nvim config"
    },
  },
  v = {
    -- Simple j/k mappings for visual mode without expressions
    -- fixes an intermittent problem with some expressions
    ["j"] = { "j", "Move down" },
    ["k"] = { "k", "Move up" },
  },
  x = {
    ["<M-j>"] = {
      ":m '>+1<CR>gv=gv",
      "Move selected lines down",
    },
    ["<M-k>"] = {
      ":m '<-2<CR>gv=gv",
      "Move selected lines up",
    },
    ["<M-/>"] = {
      toggle_multiline_comment,
      "Toggle comment",
    },
  },
  i = {
    -- Delete word backwards without yanking
    ["<M-BS>"] = { '<C-o>"_db', "Delete word backwards" },

    -- Delete word forwards without yanking
    ["<M-d>"] = { '<C-o>"_dw', "Delete forward word" },
    ["<M-j>"] = {
      "<Esc>:move .+1<CR>==gi",
      "Move line down",
    },
    ["<M-k>"] = {
      "<Esc>:move .-2<CR>==gi",
      "Move line up",
    },
  },
}
return M
