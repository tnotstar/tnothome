--
-- ~/Local/etc/nvim/lua/my/options.lua
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
vim.opt.timeoutlen = 500               -- key mapping time out on 500ms
                                       -- always use the global clipboard
vim.opt.clipboard:append('unnamedplus')

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
if vim.fn.has('mouse') then            -- if has('mouse'),enable mouse mode 
  vim.opt.mouse = 'a'                    -- and copy&paste with the `shift` key
end
