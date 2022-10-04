"
" ~/Local/etc/nvim/init.vim
"

"""
" common settings
"

if &compatible
    set nocompatible                   " use vim settings, rather than vi ones
endif

" set up common flags
set number                             " display line numbers
set nowrap                             " by default, disable word wrap
set confirm                            " ask to save changes before next one
set showmatch                          " display matching brackets
set cursorline                         " highlight the cursor line
set nomodeline                         " disable modelines for security
set hidden                             " allow hidden buffers when abandon them

" set up common parameters
set timeoutlen=200                     " key mapping time out on 200ms
set history=4096                       " how many commands of history to recall
set cmdheight=2                        " set the command window height to 2
set scrolloff=5                        " show a few lines of context around the cursor
set display=truncate                   " show @@@ in the last line, if truncated
set clipboard=unnamedplus              " always use the global clipboard

" set up tabs/spaces options
set expandtab                          " convert tabs to spaces
set tabstop=4                          " use 4 spaces for tabs
set shiftwidth=4                       " use 4 spaces for indentation
set softtabstop=4                      " backspace key treat 4 spaces as 1 tab

"""
" file handling settings
"

" set up encoding and file format
set fileformat=unix                    " use `unix` file formats by default
set fileencoding=utf-8                 " the encoding written to file.
set encoding=utf-8                     " the encoding displayed.

" enable file type detection
if has('autocmd')
    filetype plugin indent on          " enable file type, plugins and indent
endif

" switch syntax highlighting on
if has('syntax')
    if !exists('g:syntax_on')
        syntax on
    endif
endif

"""
" terminal settings
"

if &t_Co > 2
    set t_Co=256                       " try with 256 colors
    set termguicolors                  " enable 24-bit rgb color in the tui
    colorscheme desert                 " set default color scheme
endif

" set up terminal options
set t_vb=                              " reset the terminal code for visual bell
set visualbell                         " use visual bell instead of beeping

" set up key remappings
let mapleader="\<Space>"               " first, set leader key up!
noremap <Space> <Nop>
                                       " disable search highlighting
nmap <Leader>g :noh<CR>
                                       " ctrl-shift-x is `cut`
vnoremap <C-S-X> "+x
                                       " ctrl-shift-c is `copy`
vnoremap <C-S-C> "+y
                                       " ctrl-shift-v is `paste`
noremap <C-S-V> "+gp

" set up mouse options
if has('mouse')                        " enable mouse mode
    set mouse=a                          " copy&paste with the `shift` key
endif

" EOF vim:ft=vim:tw=78
