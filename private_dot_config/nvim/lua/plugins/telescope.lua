return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require "telescope.actions"
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      multi_icon = "",
      mappings = {
        i = {
          ["<Tab>"] = actions.move_selection_worse,
          ["<S-Tab>"] = actions.move_selection_better,
        },
        n = {
          ["<Tab>"] = actions.move_selection_worse,
          ["<S-Tab>"] = actions.move_selection_better,
        },
      },
    })
    return opts
  end,
}
