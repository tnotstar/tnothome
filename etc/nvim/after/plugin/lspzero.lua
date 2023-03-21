--
-- ~/Local/etc/nvim/lua/my/lspzero.lua
--

local lsp = require('lsp-zero').preset('recommended')

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
