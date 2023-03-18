--
-- ~/Local/etc/nvim/lua/my/keymaps.lua
--

vim.g.mapleader = ' '

vim.keymap.set('n', '<Leader>tt', vim.cmd.NvimTreeToggle)
vim.keymap.set('n', '<Leader>tf', vim.cmd.NvimTreeFocus)
vim.keymap.set('n', '<Leader>tp', vim.cmd.NvimTreeFindFile)
vim.keymap.set('n', '<Leader>tx', vim.cmd.NvimTreeCollapse)

local telescope_builtin = require('telescope.builtin')

vim.keymap.set('n', '<Leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<Leader>gf', telescope_builtin.git_files, {})

vim.keymap.set('n', '<Leader>gg', vim.cmd.Git)

local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<Leader>hp', mark.add_file)
vim.keymap.set('n', '<Leader>hg', ui.toggle_quick_menu)

--
-- set up legacy key remappings
--
                                       -- disable search highlighting
vim.keymap.set('n', '<Leader>gh', '<ESC>:noh<CR>')

vim.keymap.set('', '<A-j>', ':m+1<CR>==', { noremap=true })
vim.keymap.set('', '<A-k>', ':m-2<CR>==', { noremap=true })
vim.keymap.set('i', '<A-j>', '<Esc>:m+1<CR>==gi', { noremap=true })
vim.keymap.set('i', '<A-k>', '<Esc>:m-2<CR>==gi', { noremap=true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap=true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap=true })

vim.keymap.set('v', '<C-C>', '"+y', { noremap=true, silent=true })
vim.keymap.set('v', '<C-Insert>', '"+y', { noremap=true, silent=true })

vim.keymap.set('v', '<C-X>', '"+x', { noremap=true, silent=true })
vim.keymap.set('v', '<S-Del>', '"+x', { noremap=true, silent=true })

vim.keymap.set('', '<C-V>', '"+gP', { noremap=true, silent=true })
vim.keymap.set('', '<S-Insert>', '"+gP', { noremap=true, silent=true })
