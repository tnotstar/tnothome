--
-- ~/Local/etc/nvim/lua/my/packer.lua
--

vim.cmd 'packadd packer.nvim'

require('packer').startup(function(use)

  -- Package manager self-managed
  use('wbthomason/packer.nvim')

  -- Mason, easily install and manage LSP servers, DAP servers,
  -- linters, and formatters.
  use({
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  })

  --
  use({
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      {'hrsh7th/cmp-nvim-lua'},     -- Optional
      {'hrsh7th/cmp-path'},         -- Optional
      {'hrsh7th/cmp-buffer'},       -- Optional
      {'saadparwaiz1/cmp_luasnip'}, -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      {'rafamadriz/friendly-snippets'}, -- Optional
    }
  })

  -- Treesitter configurations and abstraction layer for Neovim.
  use({
    'nvim-treesitter/nvim-treesitter',
    { run = ':TSUpdate' },
  })

  -- Rosé Pine, all natural pine, faux fur and a bit of soho vibes.
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
  })

  -- A blazing fast and easy to configure neovim statusline plugin.
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  })

  -- Automatically adjusts 'shiftwidth' and 'expandtab' heuristically
  use('tpope/vim-sleuth')

  -- A Git wrapper so awesome, it should be illegal.
  use('tpope/vim-fugitive')

  -- Telescope for Find, Filter, Preview, Pick, ...
  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
  })

  -- Go to the files you want
  use('theprimeagen/harpoon')

end)
