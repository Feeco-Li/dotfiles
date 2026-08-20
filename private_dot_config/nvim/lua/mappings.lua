require "nvchad.mappings"
local map = vim.keymap.set

-- Float window helpers
local diag_whl =
  "Normal:DiagnosticFloatNormal,FloatBorder:DiagnosticFloatBorder,DiagnosticError:DiagnosticFloatError,DiagnosticWarn:DiagnosticFloatWarn,DiagnosticInfo:DiagnosticFloatInfo,DiagnosticHint:DiagnosticFloatHint"
local function focus_float(bufnr, winnr, whl)
  if not winnr or not vim.api.nvim_win_is_valid(winnr) then
    return
  end
  if whl then
    vim.wo[winnr].winhighlight = whl
  end
  vim.api.nvim_set_current_win(winnr)
  -- Override q in float to close it (instead of triggering quit-neovim mapping)
  vim.keymap.set("n", "q", function()
    pcall(vim.api.nvim_win_close, winnr, true)
  end, { buffer = bufnr, noremap = true, silent = true })
end

-- Custom LSP hover: make the request directly so we control the float
local function open_styled_hover()
  local cur_buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = cur_buf, method = "textDocument/hover" })
  if #clients == 0 then
    return
  end
  local params = vim.lsp.util.make_position_params(0, clients[1].offset_encoding)
  vim.lsp.buf_request(cur_buf, "textDocument/hover", params, function(err, result)
    if err or not result or not result.contents then
      return
    end
    local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    if not lines or vim.tbl_isempty(lines) then
      return
    end
    vim.schedule(function()
      local fbufnr, winnr = vim.lsp.util.open_floating_preview(lines, "markdown", {
        border = "rounded",
        focusable = true,
      })
      if winnr then
        vim.api.nvim_win_set_hl_ns(winnr, vim.api.nvim_create_namespace("feeco_hover"))
        focus_float(fbufnr, winnr)
      end
    end)
  end)
end

-- Feeco's custom mappings
map("n", "O", "o<ESC>")
map({ "n", "v" }, "E", "g_")
map("o", "E", "g_")
map({ "n", "v", "o" }, "b", function()
  vim.fn.search([[\v<\k]], "bW")
end, { desc = "Jump to previous English letter, not punctuation." })
map({ "n", "v", "o" }, "e", function()
  vim.fn.search([[\v\k>]], "W")
end, { desc = "Jump to end of next English word, not punctuation." })
map("n", "B", "0")

-- Jump to first alphabetic character
map({ "n", "v", "o" }, "w", function()
  vim.fn.search([[\v<\k]], "W")
end, { desc = "Jump to next English letter, not punctuation." })

-- Jump to first alphabetic character on next line
map({ "n", "v", "o" }, "W", function()
  local current_line = vim.fn.line "."
  local total_lines = vim.fn.line "$"

  -- Check if we're not on the last line
  if current_line < total_lines then
    -- Move to next line without modifying search history
    vim.fn.cursor(current_line + 1, 1)
    -- Search from beginning of line
    vim.fn.search([[\a]], "c", current_line + 1)
  else
    -- Optionally: provide feedback or wrap to first line
    vim.notify("Already at last line", vim.log.levels.INFO)
  end
end, { desc = "Jump to first English letter of the next line" })

-- Telescope
map({ "n", "i", "v" }, "<A-,>", "<cmd>Telescope<CR>", { desc = "show all list pickers" })
-- Telescope Commands
map({ "n", "i", "v" }, "<A-.>", "<cmd>Telescope commands<CR>", { desc = "show all commands in telescope" })

-- File Navigation

-- Telescope Find Files
map({ "n", "i", "v" }, "<A-i>", "<cmd>Telescope find_files<CR>", { desc = "find files" })
-- Find Defination
map({ "n", "i", "v" }, "<A-I>", vim.lsp.buf.definition, { desc = "find defination" })
-- Open last file
map({ "n", "i", "v" }, "<A-K>", "<C-o>", { desc = "go to last position" })
-- Open forward file
map({ "n", "i", "v" }, "<A-J>", "<C-i>", { desc = "go to forward position" })
-- Telescope list document symbols
map({ "n", "i", "v" }, "<A-d>", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "list symbols in a file" })
-- Telescope Find Occurrence
map({ "n", "i", "v" }, "<C-f>", "<cmd>Telescope live_grep<CR>", { desc = "search a text globally inside a project" })

-- Editing
-- Save and Format Files
map("n", "<A-s>", function()
  vim.cmd "w"
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })
-- close tabe
map({ "n", "i", "v" }, "<A-w>", "<cmd>bp<bar>bd#<CR>", { desc = "close current buffer safely" })
-- quit (force close terminals first)
map({ "n" }, "q", function()
  -- Close all terminal buffers first
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.cmd "wqa"
end, { desc = "quit neovim" })

-- Termninal
map({ "n", "t", "i", "v" }, "<A-Space>", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "floatTerm",
    float_opts = {
      width = 0.8,
      height = 0.8,
      row = 0.1,
      col = 0.1,
      border = "double",
    },
    winopts = {
      winhighlight = "FloatBorder:DiagnosticError",
    },
  }
end, { desc = "terminal toggle floating term" })

map({ "n", "t" }, "<A-S-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-S-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

-- Navigation
map("n", "J", "10j", { desc = "shift+j jump 10 lines down" })
map("n", "K", "10k", { desc = "shift+k jump 10 lines up" })
map("n", "M", "J", { desc = "join current line with the next" })

-- toggle comments
map("n", "<A-c>", "gcc", { desc = "toggle comment", remap = true })
map("v", "<A-c>", "gc", { desc = "toggle comment", remap = true })

-- global: focus nvim-tree
map({ "n", "i", "v" }, "<A-e>", "<Cmd>NvimTreeFocus<CR>", {
  desc = "focus file explorer",
  noremap = true,
  silent = true,
})

-- show jump list
map("n", "<A-;>", "<cmd>Telescope jumplist<CR>", { desc = "show jumplist" })

-- Hover: open diagnostics/LSP hover with Space Space
map("n", "<leader><Space>", function()
  -- If already in a float, close it and return to source buffer
  local cur_win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(cur_win).relative ~= "" then
    pcall(vim.api.nvim_win_close, cur_win, true)
    return
  end

  local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
  if #diags > 0 then
    local bufnr, winnr = vim.diagnostic.open_float { border = "rounded", focusable = true }
    if winnr then
      focus_float(bufnr, winnr, diag_whl)
    end
  else
    open_styled_hover()
  end
end, { desc = "open diagnostics or LSP hover" })

-- Esc closes any floating window and clears search highlight
map("n", "<Esc>", function()
  vim.cmd "nohlsearch"
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end, { desc = "close floating windows, clear search highlight" })

-- Jump between diagnostics
vim.keymap.del("n", "]d")
vim.keymap.del("n", "[d")
local function goto_diagnostic(next)
  -- Close any existing float first
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  local goto_fn = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  goto_fn { float = false }
  vim.schedule(function()
    local _, winnr = vim.diagnostic.open_float { border = "rounded" }
    if winnr then
      vim.wo[winnr].winhighlight =
        "Normal:DiagnosticFloatNormal,FloatBorder:DiagnosticFloatBorder,DiagnosticError:DiagnosticFloatError,DiagnosticWarn:DiagnosticFloatWarn,DiagnosticInfo:DiagnosticFloatInfo,DiagnosticHint:DiagnosticFloatHint"
    end
  end)
end

map("n", "<A-S-n>", function()
  goto_diagnostic(true)
end, { desc = "jump to next diagnostic" })
map("n", "<A-S-b>", function()
  goto_diagnostic(false)
end, { desc = "jump to previous diagnostic" })

-- Toggle comment visibility: hide/show all comments in the current buffer
local _comment_folds_active = {}  -- keyed by bufnr

map("n", "<A-S-c>", function()
  local bufnr = vim.api.nvim_get_current_buf()

  if _comment_folds_active[bufnr] then
    vim.cmd "normal! zE"
    _comment_folds_active[bufnr] = nil
    vim.notify("Comments shown", vim.log.levels.INFO)
    return
  end

  local ft = vim.bo[bufnr].filetype
  local lang = vim.treesitter.language.get_lang(ft) or ft

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  if not ok then
    vim.notify("No treesitter parser for " .. ft, vim.log.levels.WARN)
    return
  end

  local root = parser:parse()[1]:root()

  local query
  for _, q in ipairs { "[(line_comment) (block_comment)] @c", "(comment) @c" } do
    local ok2, result = pcall(vim.treesitter.query.parse, lang, q)
    if ok2 then
      query = result
      break
    end
  end
  if not query then
    vim.notify("No comment query for " .. lang, vim.log.levels.WARN)
    return
  end

  -- Collect and merge consecutive comment ranges (1-indexed lines)
  local ranges = {}
  for _, node in query:iter_captures(root, bufnr) do
    local sr, _, er, _ = node:range()
    table.insert(ranges, { sr + 1, er + 1 })
  end
  table.sort(ranges, function(a, b) return a[1] < b[1] end)

  local merged = {}
  for _, r in ipairs(ranges) do
    if #merged == 0 or r[1] > merged[#merged][2] + 1 then
      table.insert(merged, { r[1], r[2] })
    else
      merged[#merged][2] = math.max(merged[#merged][2], r[2])
    end
  end

  vim.cmd "normal! zE"

  local count = 0
  for _, r in ipairs(merged) do
    if r[2] > r[1] then
      if pcall(vim.cmd, r[1] .. "," .. r[2] .. "fold") then
        count = count + 1
      end
    end
  end

  _comment_folds_active[bufnr] = true
  vim.notify(count .. " comment block(s) hidden", vim.log.levels.INFO)
end, { desc = "toggle comment visibility" })
