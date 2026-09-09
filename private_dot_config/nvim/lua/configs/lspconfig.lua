local servers = {
  html = {},
  awk_ls = {},
  bashls = {},
  ty = {},
  ruff = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
          extraArgs = { "--", "-A", "clippy::all" },
        },
      },
    },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end
