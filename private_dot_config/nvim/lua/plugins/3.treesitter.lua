-- nvim-treesitter's `master` branch is archived and only supports Nvim 0.11.
-- `main` is the required branch for Nvim 0.12+ (this machine's snap nvim).
-- It's a full rewrite: no more `nvim-treesitter.configs`, no lazy-loading,
-- and highlight/indent must be enabled manually per-buffer.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    install_dir = vim.fn.stdpath "data" .. "/site",
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
    require("nvim-treesitter").install {
      "vim",
      "lua",
      "vimdoc",
      "html",
      "css",
      "javascript",
      "typescript",
      "python",
      "json",
      "markdown",
      "markdown_inline",
      "rust",
    }

    vim.api.nvim_create_autocmd("FileType", {
      desc = "Start treesitter highlighting/indent for filetypes with an installed parser",
      pattern = "*",
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) and vim.bo[args.buf].filetype ~= "markdown" then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
