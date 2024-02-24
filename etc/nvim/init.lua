--
-- ~/Local/etc/nvim/init.lua
--

-- ---
-- set up common options
--

vim.scriptencoding = 'utf-8' -- set the encoding of the current script

-- disable non-vim or non-lua extension languages
--
vim.g.loaded_python3_provider = 0 -- python3
vim.g.loaded_ruby_provider = 0    -- ruby
vim.g.loaded_node_provider = 0    -- node
vim.g.loaded_perl_provider = 0    -- perl

-- default legacy options
--
vim.opt.ruler = true                -- show the cursor position all the time
vim.opt.number = true               -- display line numbers
vim.opt.relativenumber = true       -- show numbers relative to current line
vim.opt.cursorline = true           -- highlight the cursor line
vim.opt.modeline = false            -- disable modelines for security
vim.opt.showmatch = true            -- display matching brackets
vim.opt.confirm = true              -- ask to save changes before next one
vim.opt.hidden = true               -- allow hidden buffers when abandon them
vim.opt.wrap = false                -- by default, disable word wrap
vim.opt.scrolloff = 5               -- show some lines of context around the cursor
vim.opt.history = 4096              -- how many commands of history to recall
vim.opt.cmdheight = 2               -- set the command window height to 2
vim.opt.display = 'truncate'        -- show @@@ in the last line, if truncated
vim.opt.timeout = false             -- disable mappings timeout
vim.opt.ttimeout = true             -- enable key code scan timeout

-- set up tabs/spaces options
--
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 4      -- use 4 spaces for tabs
vim.opt.shiftwidth = 4   -- use 4 spaces for indentation
vim.opt.softtabstop = 4  -- backspace key treat 4 spaces as 1 tab

-- set up encoding and file format
--
vim.opt.encoding = 'utf-8'     -- the display encoding
vim.opt.fileencoding = 'utf-8' -- the encoding written to file
vim.opt.fileformat = 'unix'    -- use `unix` file formats by default

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
vim.opt.termguicolors = true -- enable gui colors for terminal
vim.opt.visualbell = true    -- use visual bell instead of beeping

-- set transparent background
--
vim.cmd.highlight({ 'Normal', 'guibg=none', 'ctermbg=none' })
vim.cmd.highlight({ 'NormalFloat', 'guibg=none', 'ctermbg=none' })

-- set up mouse options
--
if vim.fn.has('mouse') then -- if has('mouse'), enable mouse mode
  vim.opt.mouse = 'a'       -- and copy&paste with the `shift` key
end

-- set up clipboard options
--
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
  }
end


-- ---
-- set up personal keyboard mappings
--

vim.g.mapleader = ' '

vim.keymap.set('n', '<C-p>', ':bprevious<CR>')
vim.keymap.set('n', '<C-n>', ':bnext<CR>')

vim.keymap.set('n', '<A-j>', ':m+1<CR>==', { noremap = true })
vim.keymap.set('i', '<A-j>', '<Esc>:m+1<CR>==gi', { noremap = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true })

vim.keymap.set('n', '<A-k>', ':m-2<CR>==', { noremap = true })
vim.keymap.set('i', '<A-k>', '<Esc>:m-2<CR>==gi', { noremap = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true })

vim.keymap.set('v', '<C-C>', '"+y', { noremap = true })
vim.keymap.set('v', '<C-Insert>', '"+y', { noremap = true })

vim.keymap.set('v', '<C-X>', '"+x', { noremap = true })
vim.keymap.set('v', '<S-Del>', '"+x', { noremap = true })

vim.keymap.set('n', '<C-V>', '"+gP', { noremap = true })
vim.keymap.set('n', '<S-Insert>', '"+gP', { noremap = true })


-- ---
-- load third-party plugins
--

local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Rosé Pine, all natural pine, faux fur and a bit of soho vibes
Plug('rose-pine/neovim', { as = 'rose-pine' })

-- Automatically adjusts 'shiftwidth' and 'expandtab' heuristically
Plug('tpope/vim-sleuth')

-- All the lua functions I don't want to write twice.
Plug('nvim-lua/plenary.nvim')

-- A blazing fast and easy to configure neovim statusline plugin
Plug('nvim-lualine/lualine.nvim', { requires = { 'nvim-tree/nvim-web-devicons' } })

-- A Git wrapper so awesome, it should be illegal
Plug('tpope/vim-fugitive')

-- A GitHub extension for fugitive.vim
Plug('tpope/vim-rhubarb')

-- Git integration for buffers
Plug('lewis6991/gitsigns.nvim')

-- Nvim Treesitter configurations and abstraction layer
Plug('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

-- A starting point to setup some lsp related features in neovim
Plug('VonHeikemen/lsp-zero.nvim', { branch = 'v3.x' })

-- Quickstart configs for Nvim LSP
Plug('neovim/nvim-lspconfig')

-- Easily install and manage LSP servers, DAP servers, linters, and formatters
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')

-- A completion plugins for neovim (coded in Lua)
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-nvim-lua')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-buffer')

-- Snippet Engine for Neovim written in Lua
Plug('L3MON4D3/LuaSnip', { tag = 'v2.*', ['do'] = 'make install_jsregexp' })

-- Telescope for Find, Filter, Preview, Pick, ...
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })

-- Neovim plugin for GitHub Copilot
Plug('github/copilot.vim')

vim.call('plug#end')

-- ---
-- set up plugins configurations
--

-- set up colors scheme
--
vim.cmd.colorscheme('rose-pine')

-- settings of `lualine` plugin
--
require('lualine').setup()

-- settings of `nvim-treesitter` plugin
--
require('nvim-treesitter.configs').setup({
  -- A list of parser names, or 'all' (the four listed parsers should always be
  -- installed)
  ensure_installed = {
    'vim', 'lua', 'go', 'python', 'javascript', 'typescript',
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

local lspzero = require('lsp-zero')
local lspconf = require('lspconfig')
local lsputil = require('lspconfig.util')

-- settings of `lspzero` plugin
--
lspzero.on_attach(function(_, bufnr)
  lspzero.default_keymaps({ buffer = bufnr })
end)

-- settings of `mason` plugin
--
require('mason').setup()

-- settings of `mason-lspconfig` plugin
--
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'gopls',
    'rust_analyzer',
    'pyright',
    'denols',
    'tsserver',
  },
  handlers = {
    lspzero.default_setup,

    -- custom configuration for `lua_ls` language server
    lua_ls = lspconf.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim', 'require', 'use', 'print' },
          },
        },
      },
    }),

    -- custom configuration for `denols` language server
    denols = lspconf.denols.setup({
      init_options = {
        enable = true,
        lint = true,
        unstable = true,
      },
      root_dir = lsputil.root_pattern('deps.ts'),
    }),

    -- custom configuration for `tsserver` language server
    tsserver = lspconf.tsserver.setup({
      init_options = {
        preferences = {
          quotePreference = 'single',
          disableSuggestions = true,
        },
      },
      single_file_support = false,
      root_dir = lsputil.root_pattern('package.json'),
    }),
  },
})

-- settings of autocompletion plugins
--
local cmp = require('cmp')

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- `Ctrl+E` to close completion menu
    ['<C-e>'] = cmp.mapping.close(),

    -- Move up and down between completion menu items
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),

    -- Scroll up and down in the completion documentation
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  })
})

-- settings of `copilot` plugin
--
vim.g.copilot_filetypes = {
  ['*'] = false,
  ['lua'] = true,
  ['go'] = true,
  ['rust'] = true,
  ['python'] = true,
  ['javascript'] = true,
  ['typescript'] = true,
}


-- ---
-- set up plugins' keyboard mappings
--

-- set up mappings for `telescope` plugin
--
local telescope_builtin = require('telescope.builtin')

vim.keymap.set('n', '<Leader>tf', telescope_builtin.find_files, {})
vim.keymap.set('n', '<Leader>tg', telescope_builtin.git_files, {})

vim.keymap.set('n', '<Leader>gg', vim.cmd.Git)
vim.keymap.set('n', '<Leader>sh', '<ESC>:noh<CR>')

-- ---
-- set up diagnostics
--

vim.diagnostic.config({
  virtual_text = true,
})


-- ---
-- set up neovide options
--

if vim.g.neovide then
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_hide_mouse_when_typing = true

  vim.opt.guifont = 'Fira\\ Code:h10'
  vim.opt.linespace = 0

  vim.cmd.colorscheme('rose-pine')
end

-- EOF