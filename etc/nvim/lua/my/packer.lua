vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)

  -- Package manager self-managed
  use 'wbthomason/packer.nvim'

  -- Mason, easily install and manage LSP servers, DAP servers,
  -- linters, and formatters.
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  -- Rosé Pine, all natural pine, faux fur and a bit of soho vibes
  use {
    'rose-pine/neovim',
    as = 'rose-pine',
  }

  -- Telescope for Find, Filter, Preview, Pick, ...
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

end)

