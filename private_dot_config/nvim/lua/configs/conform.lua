require("conform").setup {
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    lua = { "stylua" },
    python = { "ruff_format", "ruff_fix" },
    rust = { "rustfmt" },
  },
  formatters = {
    prettier = {
      prepend_args = { "--print-width", "200" },
    },
  },
  format_on_save = {
    timeout_ms = 5000, -- increase timeout to 5 seconds
  },
}
