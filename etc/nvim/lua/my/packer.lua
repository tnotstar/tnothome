--
-- ~/Local/etc/nvim/lua/my/packer.lua
--

vim.cmd 'packadd packer.nvim'

require('packer').startup(function(use)

  -- Package manager self-managed
  use('wbthomason/packer.nvim')

  -- Automatically adjusts 'shiftwidth' and 'expandtab' heuristically
  use('tpope/vim-sleuth')

  -- Mason, easily install and manage LSP servers, DAP servers,
  -- linters, and formatters.
  use({
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  })

  -- Rosé Pine, all natural pine, faux fur and a bit of soho vibes.
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
  })

  -- Telescope for Find, Filter, Preview, Pick, ...
  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
  })

  -- A Git wrapper so awesome, it should be illegal.
  use('tpope/vim-fugitive')

  -- Treesitter configurations and abstraction layer for Neovim.
  use({
    'nvim-treesitter/nvim-treesitter',
    { run = ':TSUpdate' },
  })

  -- View treesitter information directly in Neovim!
  use('nvim-treesitter/playground')

  -- A file explorer tree for neovim written in lua.
  use({
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  })

  -- A blazing fast and easy to configure neovim statusline plugin.
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  })

  -- Go to the files you want
  use('theprimeagen/harpoon')

end)
