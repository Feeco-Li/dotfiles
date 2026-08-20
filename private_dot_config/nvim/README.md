# Neovim Configuration Structure

## 0. `init.lua`
Entry file for Neovim configuration.

## 1. `lua/`
Main folder for all Lua configs.

- **`chadrc.lua`** – Core config; loads and integrates modules and plugins.

## 2. `lua/configs/`
Function-specific configuration modules:

- **`conform.lua`** – Code formatter (e.g., Prettier).  
- **`lazy.lua`** – Configures `lazy.nvim` plugin behavior.  
- **`lspconfig.lua`** – Language Server Protocol setup.  
- **`luasnip.lua`** – `LuaSnip` snippet definitions and triggers.  
- **`nvimtree.lua`** – `nvim-tree` file explorer settings.

## 3. `lua/feeco_custom_commands/`
Custom commands folder (e.g., `git_reset.lua`).

## 4. `lua/mappings.lua`
Centralized key mappings.

## 5. `lua/options.lua`
Neovim options (UI, performance, etc.).

## 6. `lua/plugins/`
Plugin-specific configs:

- **`outline.lua`** – Code outline plugin.  
- **`luasnip.lua`** – `LuaSnip` plugin config.  
- **`init.lua`** – Loads all plugin configs.  
- Other language/tool plugins: `python-tool.lua`, `render-markdown.lua`, `typescrip-tool.lua`, `ty-python.lua`.

## 7. `lua/snippets/`
Code snippets:

- **`html.lua`** – HTML snippets.  
- **`typescriptreact.lua`** – TS React snippets.

## 8. `.stylua.toml`
Stylua formatting rules.

---

**Summary:**  
The structure is modular, clear, and maintainable, separating plugins, language support, snippets, and custom commands for efficient configuration.
