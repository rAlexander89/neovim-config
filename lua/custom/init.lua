-- Custom initialization file

-- Allow per-project .nvim.lua files to configure rust-analyzer scope
vim.o.exrc = true
vim.o.secure = true

-- Everything below registers into this group, so re-sourcing this file (see
-- :Reset at the bottom) replaces the autocmds instead of stacking duplicates.
local augroup = vim.api.nvim_create_augroup("CustomConfig", { clear = true })

-- Force terraform indentation settings on every buffer enter.
-- Belt-and-suspenders: after/indent and after/ftplugin both run first,
-- but treesitter's BufEnter autocmd can still override them.
-- vim.schedule defers to after all current callbacks so this always wins.
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = augroup,
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.schedule(function()
      vim.bo.indentexpr = ""
      vim.opt_local.smartindent = true
    end)
  end,
})

-- Keep the indent when pressing <CR> inside an already backslash-continued
-- C/C++ macro body. nvim-treesitter's indent queries don't understand line
-- continuations, so without this the new line snaps back to column 0.
--
-- This only ever adjusts indentation -- it never inserts a backslash. The
-- trigger is strictly "the line being split is already a continuation", not
-- "this is a #define", so a run of ordinary one-line defines is untouched.
--
-- A keymap (rather than 'indentexpr') is used deliberately: indentexpr is
-- reassigned asynchronously by treesitter when its indent module attaches,
-- which races with any attempt to override it. A keymap isn't subject to
-- that race.
local function continues_a_macro(lnum)
  if vim.fn.getline(lnum):match("\\%s*$") then
    return true
  end
  return lnum > 1 and vim.fn.getline(lnum - 1):match("\\%s*$") ~= nil
end

-- Treesitter's indent module is disabled for c/cpp (see plugins.lua), but it
-- still sets 'indentexpr' when it attaches, which would override 'cindent'.
-- Clearing it on a deferred callback runs after that attach.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp" },
  callback = function()
    vim.schedule(function()
      vim.bo.indentexpr = ""
      vim.bo.cindent = true
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp" },
  callback = function(args)
    vim.keymap.set("i", "<CR>", function()
      -- This buffer-local mapping shadows cmp's global <CR> (confirm), so
      -- hand back to cmp whenever its completion menu is open.
      local ok, cmp = pcall(require, "cmp")
      if ok and cmp.visible() then
        cmp.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true }
        return
      end

      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      if not continues_a_macro(row) then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
        return
      end

      local line = vim.api.nvim_get_current_line()
      local before = line:sub(1, col)
      local after = line:sub(col + 1)

      -- Carry the current indent forward, stepping in after an opening brace,
      -- since we've taken over from the normal indent machinery here.
      local sw = vim.fn.shiftwidth()
      local base = vim.fn.indent(row)
      local opens = before:gsub("%s*\\%s*$", ""):match("{%s*$") ~= nil
      local pad = string.rep(" ", opens and base + sw or base)

      if opens and after:match("^%s*}") then
        -- Cursor sits between a brace pair (autopairs just supplied the
        -- closer): open a body line for the cursor and drop the closer to its
        -- own line, rather than stacking both on one line.
        vim.api.nvim_buf_set_lines(0, row, row, false, { pad, string.rep(" ", base) .. after })
      else
        vim.api.nvim_buf_set_lines(0, row, row, false, { pad .. after })
      end
      vim.api.nvim_win_set_cursor(0, { row + 1, #pad })
    end, { buffer = args.buf })
  end,
})

-- Repair a macro whose continuations were lost (e.g. it was written before
-- the <CR> mapping was active, then reformatted as ordinary code). Select the
-- macro's lines and :MacroContinue to re-add trailing backslashes to all but
-- the last one.
vim.api.nvim_create_user_command("MacroContinue", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  for i, l in ipairs(lines) do
    local body = l:gsub("%s*\\%s*$", "")
    if i < #lines and body:match("%S") then
      lines[i] = body .. " \\"
    else
      lines[i] = body
    end
  end
  vim.api.nvim_buf_set_lines(0, opts.line1 - 1, opts.line2, false, lines)
end, { range = true, desc = "Add macro continuation backslashes to range" })

-- On save, restore continuations on a #define whose body is a brace block but
-- which has lost its backslashes (so it is no longer a macro at all). Scoped
-- deliberately narrow: only fires for a backslash-less #define whose body is a
-- brace block, and only spans through the matching close brace. Registered at
-- startup so it runs before null-ls's format-on-save, letting clang-format
-- then see -- and align -- a well-formed macro.
local function restore_macro_continuations(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local changed = false
  local i = 1

  while i <= #lines do
    local head, body = lines[i], lines[i + 1]
    local from
    if head:match("^%s*#%s*define") and not head:match("\\%s*$") then
      -- The brace block is not why continuations are needed -- a multi-line
      -- #define needs them regardless. It is simply the only reliable marker
      -- for where the macro ends once the backslashes are gone. The block may
      -- open on the #define line itself or on the line below it.
      if head:match("{") then
        from = i
      elseif body and (body:match("^%s*do%s*{") or body:match("^%s*{")) then
        from = i + 1
      end
    end

    if from then
      -- Walk the block to its matching close brace to find the macro's end.
      local depth, last = 0, nil
      for j = from, #lines do
        local _, opens = lines[j]:gsub("{", "")
        local _, closes = lines[j]:gsub("}", "")
        depth = depth + opens - closes
        if depth <= 0 then
          last = j
          break
        end
      end

      if last then
        for j = i, last - 1 do
          if lines[j]:match("%S") then
            lines[j] = lines[j]:gsub("%s*\\?%s*$", "") .. " \\"
            changed = true
          end
        end
        i = last
      end
    end
    i = i + 1
  end

  if changed then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.cc", "*.hh", "*.cxx" },
  callback = function(args)
    restore_macro_continuations(args.buf)
  end,
})

-- Re-source this file without restarting nvim. Buffer-local mappings are set
-- from a FileType autocmd, which won't re-fire on its own for buffers that are
-- already open, so re-trigger it across every loaded buffer afterwards.
vim.api.nvim_create_user_command("Reset", function()
  local path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]
  if not path then
    vim.notify("could not locate lua/custom/init.lua", vim.log.levels.ERROR)
    return
  end

  local ok, err = pcall(dofile, path)
  if not ok then
    vim.notify("reset failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd "doautocmd FileType"
      end)
    end
  end

  vim.notify("custom config reloaded", vim.log.levels.INFO)
end, { desc = "Re-source lua/custom/init.lua" })

-- Let a bare ":reset" reach :Reset (user commands must start uppercase). The
-- guard keeps the expansion from firing mid-line, so things like
-- ":!git reset --hard" are left alone.
vim.cmd [[cnoreabbrev <expr> reset (getcmdtype() == ':' && getcmdline() ==# 'reset') ? 'Reset' : 'reset']]

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
