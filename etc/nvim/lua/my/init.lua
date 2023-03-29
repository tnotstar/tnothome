--
-- ~/Local/etc/nvim/lua/my/init.lua
--

require('my.plugins')
require('my.options')
require('my.keymaps')
require('my.colors')

if vim.g.neovide then
  require('my.neovide')
end
