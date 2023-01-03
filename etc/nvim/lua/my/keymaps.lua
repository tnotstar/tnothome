vim.g.mapleader = ' '

vim.keymap.set('n', '<Leader>pv', vim.cmd.Ex)

local telescope_builtin = require('telescope.builtin')

vim.keymap.set('n', '<Leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<Leader>gf', telescope_builtin.git_files, {})
vim.keymap.set('n', '<Leader>gs', function()
  telescope_builtin.grep_string({ search = vim.fn.input("Grep> ") })
end)

--
-- set up legacy key remappings
--

                                       -- disable search highlighting
vim.keymap.set('n', '<Leader>gh', '<ESC>:noh<CR>')

vim.keymap.set('v', '<C-C>', '"+y', { noremap=true, silent=true })
vim.keymap.set('v', '<S-Del>', '"+y', { noremap=true, silent=true })

vim.keymap.set('v', '<C-X>', '"+x', { noremap=true, silent=true })
vim.keymap.set('v', '<C-Insert>', '"+x', { noremap=true, silent=true })

vim.keymap.set('', '<C-V>', '"+gP', { noremap=true, silent=true })
vim.keymap.set('', '<S-Insert>', '"+gP', { noremap=true, silent=true })
