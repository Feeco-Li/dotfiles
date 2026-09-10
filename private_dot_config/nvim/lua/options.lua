require "nvchad.options"

-- add yours here!
local o = vim.o

-- Cursor and display options
o.cursorlineopt = "both" -- to enable cursorline and row number!
o.cursorcolumn = false -- I tried vertical cursor line, finally disable it, cuz looks weird
o.scrolloff = 8 -- reasonable scrolloff for better navigation
o.number = true -- show line numbers
o.swapfile = false -- disable swap files

-- Open nvim-tree automatically when opening a directory (optimized)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      -- Defer tree opening to avoid blocking startup
      vim.defer_fn(function()
        require("nvim-tree.api").tree.open()
      end, 50)
    end
  end,
})

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- Cursorline only in the focused window, so it doubles as a focus indicator
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    vim.wo.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    vim.wo.cursorline = false
  end,
})


-- Diagnostic underline style: use double underline for better visibility
local function set_diagnostic_highlights()
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underdouble = true, sp = "#f44747" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underdouble = true, sp = "#ff8800" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underdouble = true, sp = "#4fc1ff" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underdouble = true, sp = "#10b981" })
  -- Diagnostic float window: white bg, black text, red for errors
  vim.api.nvim_set_hl(0, "DiagnosticFloatNormal", { bg = "#ffffff", fg = "#000000" })
  vim.api.nvim_set_hl(0, "DiagnosticFloatBorder", { bg = "#ffffff", fg = "#888888" })
  vim.api.nvim_set_hl(0, "DiagnosticFloatError", { bg = "#ffffff", fg = "#cc0000", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticFloatWarn", { bg = "#ffffff", fg = "#cc6600", bold = true })
  vim.api.nvim_set_hl(0, "DiagnosticFloatInfo", { bg = "#ffffff", fg = "#000000" })
  vim.api.nvim_set_hl(0, "DiagnosticFloatHint", { bg = "#ffffff", fg = "#000000" })
  -- LSP hover float: dark bg so default theme colors stay readable
  local hover_ns = vim.api.nvim_create_namespace("feeco_hover")
  vim.api.nvim_set_hl(hover_ns, "Normal", { bg = "#3a3a3a" })
  vim.api.nvim_set_hl(hover_ns, "FloatBorder", { bg = "#3a3a3a", fg = "#888888" })
end
set_diagnostic_highlights()

-- Re-apply after theme changes (NvChad base46 reloads can reset highlights)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_diagnostic_highlights,
})
