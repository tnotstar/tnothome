--
-- ~/Local/etc/nvim/init.lua
--

-- ---
-- disable incompatible options
--

-- disable non-vim or non-lua extension languages
--
vim.g.loaded_python3_provider = 0      -- python3
vim.g.loaded_ruby_provider = 0         -- ruby
vim.g.loaded_node_provider = 0         -- node
vim.g.loaded_perl_provider = 0         -- perl


-- ---
-- load and preconfigure plugins
--

-- load `packer` at first
--
vim.cmd 'packadd packer.nvim'

-- load rest of plugins
--
require('packer').startup(function(use)

  -- Package manager self-managed
  use('wbthomason/packer.nvim')

  -- Mason, easily install and manage LSP servers, DAP servers,
  -- linters, and formatters
  use({
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  })

  -- A starting point to setup some lsp related features in neovim
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

  -- Treesitter configurations and abstraction layer for Neovim
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  })

  -- Rosé Pine, all natural pine, faux fur and a bit of soho vibes
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
  })

  -- A blazing fast and easy to configure neovim statusline plugin
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  })

  -- Automatically adjusts 'shiftwidth' and 'expandtab' heuristically
  use('tpope/vim-sleuth')

  -- A Git wrapper so awesome, it should be illegal
  use('tpope/vim-fugitive')

  -- A GitHub extension for fugitive.vim
  use('tpope/vim-rhubarb')

  -- Git integration for buffers
  use('lewis6991/gitsigns.nvim')

  -- Telescope for Find, Filter, Preview, Pick, ...
  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
  })

  -- File manager for Neovim powered by nnn.
  use({
    'luukvbaal/nnn.nvim',
    config = function() require('nnn').setup() end
  })

  -- Neovim plugin for GitHub Copilot
  use('github/copilot.vim')

end)


-- ---
-- set up plugins options
--

-- settings of `lualine` plugin
--
require('lualine').setup()

-- settings of `treesitter` plugin
--
require('nvim-treesitter.configs').setup({
    -- A list of parser names, or 'all' (the four listed parsers should always be
    -- installed)
    ensure_installed = {
      'vim', 'c', 'cpp', 'lua', 'python', 'javascript', 'typescript', 'go', 'rust',
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed
    -- locally
    auto_install = true,

    -- Enable smart-indentation
    indent = {
        enable = true,
    },

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same
        -- time. Set this to `true` if you depend on 'syntax' being enabled
        -- (like for indentation). Using this option may slow down your editor,
        -- and you may see some duplicate highlights. Instead of true it can
        -- also be a list of languages
        additional_vim_regex_highlighting = false,
    },
})

-- settings of `mason` plugin
--
require('mason').setup()

-- settings of `lspzero` plugin
--
local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.set_preferences({
  suggest_lsp_servers = true,
})

lsp.ensure_installed({
  'gopls',
  'pyright',
  'denols',
  'tsserver',
  'rust_analyzer',
})

local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

lspconfig.lua_ls.setup(
  lsp.nvim_lua_ls()
)

lspconfig.denols.setup({
  init_options = {
    enable = true,
    lint = true,
    unstable = true,
  },
});

lspconfig.tsserver.setup({
  init_options = {
    preferences = {
      quotePreference = 'single',
      disableSuggestions = true,
    },
  },
  single_file_support = false,
  root_dir = util.root_pattern('package.json'),
})

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })

  local options = { noremap = true, buffer = bufnr }

  -- enable completion trigger by <C-x><C-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, options)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, options)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, options)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, options)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, options)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, options)
  vim.keymap.set('n', '<Leader>K', vim.lsp.buf.signature_help, options)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, options)
end)

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mapping = lsp.defaults.cmp_mappings({
  ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
  mapping = cmp_mapping
})

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
})

-- settings of `copilot` plugin
--
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = {
  ['*'] = false,
  ['javascript'] = true,
  ['typescript'] = true,
  ['lua'] = true,
  ['c'] = true,
  ['cpp'] = true,
  ['rust'] = true,
  ['go'] = true,
  ['python'] = true,
}

vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Accept("<CR>")', { silent = true, expr = true })


-- ---
-- set up colors scheme
--

vim.cmd.colorscheme('rose-pine')

-- set transparent background
vim.cmd.highlight({ 'Normal', 'guibg=none', 'ctermbg=none' })
vim.cmd.highlight({ 'NormalFloat', 'guibg=none', 'ctermbg=none' })


-- ---
-- set up personal keyboard mappings
--

vim.g.mapleader = ' '

vim.keymap.set('n', '<Leader>nx', vim.cmd.NnnExplorer)
vim.keymap.set('n', '<Leader>nn', function() vim.cmd.NnnPicker('%:p:h') end)

local telescope_builtin = require('telescope.builtin')

vim.keymap.set('n', '<Leader>tf', telescope_builtin.find_files, {})
vim.keymap.set('n', '<Leader>tg', telescope_builtin.git_files, {})

vim.keymap.set('n', '<Leader>gG', vim.cmd.Git)


-- ---
-- set up legacy key remappings
--
                                       -- disable search highlighting
vim.keymap.set('n', '<Leader>gh', '<ESC>:noh<CR>')

vim.keymap.set('n', '<C-p>', ':bprevious<CR>')
vim.keymap.set('n', '<C-n>', ':bnext<CR>')

vim.keymap.set('n', '<A-j>', ':m+1<CR>==', { noremap=true })
vim.keymap.set('n', '<A-k>', ':m-2<CR>==', { noremap=true })
vim.keymap.set('i', '<A-j>', '<Esc>:m+1<CR>==gi', { noremap=true })
vim.keymap.set('i', '<A-k>', '<Esc>:m-2<CR>==gi', { noremap=true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap=true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap=true })

vim.keymap.set('v', '<C-C>', '"+y', { noremap=true })
vim.keymap.set('v', '<C-Insert>', '"+y', { noremap=true })
vim.keymap.set('v', '<C-X>', '"+x', { noremap=true })
vim.keymap.set('v', '<S-Del>', '"+x', { noremap=true })
vim.keymap.set('n', '<C-V>', '"+gP', { noremap=true })
vim.keymap.set('n', '<S-Insert>', '"+gP', { noremap=true })


-- ---
-- set up common options
--

-- my default legacy options
--
vim.opt.ruler = true                   -- show the cursor position all the time
vim.opt.number = true                  -- display line numbers
vim.opt.relativenumber = true          -- show numbers relative to current line
vim.opt.cursorline = true              -- highlight the cursor line
vim.opt.modeline = false               -- disable modelines for security
vim.opt.showmatch = true               -- display matching brackets
vim.opt.confirm = true                 -- ask to save changes before next one
vim.opt.hidden = true                  -- allow hidden buffers when abandon them
vim.opt.wrap = false                   -- by default, disable word wrap
vim.opt.scrolloff = 5                  -- show some lines of context around the cursor
vim.opt.history = 4096                 -- how many commands of history to recall
vim.opt.cmdheight = 2                  -- set the command window height to 2
vim.opt.display = 'truncate'           -- show @@@ in the last line, if truncated
vim.opt.timeout = false                -- disable mappings timeout
vim.opt.ttimeout = true                -- enable key code scan timeout
                                       -- always use the global clipboard
vim.opt.clipboard:append('unnamed')    -- put all text operations in the '*' register

-- set up tabs/spaces options
--
vim.opt.expandtab = true               -- convert tabs to spaces
vim.opt.tabstop = 4                    -- use 4 spaces for tabs
vim.opt.shiftwidth = 4                 -- use 4 spaces for indentation
vim.opt.softtabstop = 4                -- backspace key treat 4 spaces as 1 tab

-- set up encoding and file format
--
vim.opt.encoding = 'utf-8'             -- the display encoding 
vim.opt.fileencoding = 'utf-8'         -- the encoding written to file
vim.opt.fileformat = 'unix'            -- use `unix` file formats by default

-- enable file type, plugins and indent
--
if vim.fn.has('autocmd') then
  vim.cmd.filetype('plugin indent on')
end

-- switch syntax highlighting on
--
if vim.fn.has('syntax') then
  if not vim.g.syntax_on then
    vim.cmd.syntax('on')
  end
end

-- terminal settings
--
vim.opt.termguicolors = true           -- enable gui colors for terminal
vim.opt.visualbell = true              -- use visual bell instead of beeping

-- set up mouse options
--
if vim.fn.has('mouse') then            -- if has('mouse'), enable mouse mode 
  vim.opt.mouse = 'a'                  -- and copy&paste with the `shift` key
end


-- ---
-- set up neovide options
--

if vim.g.neovide then

  vim.g.neovide_transparency = 0.9
  vim.g.neovide_hide_mouse_when_typing = true

  vim.opt.guifont = 'Monospace:h10'
  vim.opt.linespace = 0

  vim.cmd.colorscheme('rose-pine')

end

-- EOF
