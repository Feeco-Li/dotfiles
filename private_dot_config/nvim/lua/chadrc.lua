-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "ayu_dark",
  transparency = true,
  hl_override = {
    CursorLine = { bg = "#4D4D4D" },
    CursorColumn = { bg = "#333333" },
    -- change comment color in neovim globally
    Comment = { fg = "#00ffff" },
    -- Changes color of comments when Treesitter is active, only in this approach, .tsx file comments color will take effect as well, otherwise, .tsx file comment stay the black instead of cyan
    ["@comment"] = { fg = "#00ffff" },
    Search = { bg = "#ffff00" },
    TbBufOn = { fg = "#ffff00" },
    TbBufOff = { fg = "#ffffff" },
  },
}

M.ui = {
  theme = "ayu_dark",
  statusline = {
    theme = "default",
    order = { "f", "%=", "pct", "git", "lsp_msg", "lsp", "cwd" },
    modules = { f = "%F ", pct = "%l/%L " },
  },
}

-- Load the custom feeco commands
require("feeco_custom_commands.git_reset").setup()

return M
