--
-- ~/Local/etc/nvim/init.lua
--

--
-- common settings
--

vim.opt.ruler = true                   -- show the cursor position all the time
vim.opt.cursorline = true              -- highlight the cursor line
vim.opt.number = true                  -- display line numbers
vim.opt.relativenumber = true          -- show numbers relative to current line
vim.opt.modeline = false               -- disable modelines for security
vim.opt.showmatch = true               -- display matching brackets
vim.opt.confirm = true                 -- ask to save changes before next one
vim.opt.hidden = true                  -- allow hidden buffers when abandon them
vim.opt.wrap = false                   -- by default, disable word wrap
vim.opt.scrolloff = 5                  -- show a few lines of context around the cursor
vim.opt.history = 4096                 -- how many commands of history to recall
vim.opt.cmdheight = 2                  -- set the command window height to 2
vim.opt.display = truncate             -- show @@@ in the last line, if truncated
vim.opt.clipboard = unnamedplus        -- always use the global clipboard
vim.opt.timeoutlen = 200               -- key mapping time out on 200ms

-- set up tabs/spaces options
--
vim.opt.expandtab = true               -- convert tabs to spaces
vim.opt.tabstop = 4                    -- use 4 spaces for tabs
vim.opt.shiftwidth = 4                 -- use 4 spaces for indentation
vim.opt.softtabstop = 4                -- backspace key treat 4 spaces as 1 tab

-- set up encoding and file format
--
vim.opt.fileformat = "unix"            -- use `unix` file formats by default
vim.opt.fileencoding = "utf-8"         -- the encoding written to file
vim.opt.encoding = "utf-8"             -- the encoding displayed

-- enable file type, plugins and indent
--
if vim.fn.has("autocmd") then
    vim.cmd("filetype plugin indent on")          
end

-- switch syntax highlighting on
--
if vim.fn.has("syntax") then
    if not vim.g.syntax_on then
        vim.cmd("syntax on")
    end
end

--"""
--" terminal settings
--"
--
--if &t_Co > 2
--    set t_Co=256                       " try with 256 colors
--    set termguicolors                  " enable 24-bit rgb color in the tui
--    colorscheme desert                 " set default color scheme
vim.cmd("colorscheme desert")
--endif
--
--" set up terminal options
--set t_vb=                              " reset the terminal code for visual bell
--set visualbell                         " use visual bell instead of beeping
--
--"""
--" set up key remappings
--"
--
--" disable search highlighting
--nmap <Leader>g <ESC>:noh<CR>
--
--" ctrl-s is `save`
--noremap <C-s> <ESC>:w<CR>
--
--" ctrl-x is `cut`
--vnoremap <C-x> "+x
--
--" ctrl-c is `copy`
--vnoremap <C-c> "+y
--
--" ctrl-v is `paste`
--noremap <C-v> "+gp
--
--" set up mouse options
--if has('mouse')                        " enable mouse mode
--    set mouse=a                          " copy&paste with the `shift` key
--endif
--
--" EOF vim:ft=vim:tw=78
