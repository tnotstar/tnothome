-- ~/.config/nvim/lua/config/options.lua

vim.scriptencoding = "utf-8"

local opt = vim.opt

--------------------------------------------------------------------------------
-- 1. Bootstrap & Early Optimizations (Startup latency reduction)
--------------------------------------------------------------------------------
-- Suppress remote provider lookups completely
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Disable legacy netrw (Oil.nvim is primary file manager)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Mute deprecated API warnings
vim.g.deprecation_warnings = false

--------------------------------------------------------------------------------
-- 2. Core Interaction & Timings
--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

opt.timeoutlen = 400     -- Snappy multi-key mappings evaluation
opt.updatetime = 200     -- Responsive CursorHold events for git and LSP
opt.mouse = "a"          -- Universal mouse tracking
opt.belloff = "all"      -- Kill both audio and visual bells (no flashing on SSH)

--------------------------------------------------------------------------------
-- 3. Editing Ergonomics & Indentation
--------------------------------------------------------------------------------
-- Native EditorConfig integration: overrides indentation per-project
vim.g.editorconfig = true

-- Predictable 4-space default indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.shiftround = true
opt.smartindent = true

-- Lines & layout columns
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"   -- Constant layout; prevents code jumping on diagnostics

-- Viewport margins & latency mitigation
opt.scrolloff = 5
opt.sidescrolloff = 8
opt.smoothscroll = not vim.env.SSH_CONNECTION -- Avoid frame drops over SSH

-- Line wrapping & block editing
opt.wrap = false
opt.linebreak = true
opt.virtualedit = "block"
opt.formatoptions = "jcroqlnt"

--------------------------------------------------------------------------------
-- 4. Search & Navigation
--------------------------------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit" -- Live visual substitution in command line
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.jumpoptions = "view"

--------------------------------------------------------------------------------
-- 5. System Integration & Clipboard (WSL2 / SSH OSC 52)
--------------------------------------------------------------------------------
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
  }
else
  -- Over SSH: empty string triggers native OSC 52 escape sequences
  opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
end

-- Data integrity & standards
opt.modeline = false       -- Security measure against malicious files
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileformat = "unix"
opt.endofline = true
opt.fixendofline = true
opt.spelllang = { "en" }

--------------------------------------------------------------------------------
-- 6. Persistence & File Safety (Swapless workflow)
--------------------------------------------------------------------------------
opt.swapfile = false       -- No clutter or locking issues across WSL/SSH mounts
opt.undofile = true        -- Persistent disk undo history
opt.undolevels = 10000
opt.autowrite = true       -- Auto-save on focus change or shell triggers
opt.confirm = true         -- Prompt to save on exit instead of failing

--------------------------------------------------------------------------------
-- 7. Windows & Popup Menus (No alpha blend computation)
--------------------------------------------------------------------------------
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.winminwidth = 5

-- Completion menu: zero opacity overhead (pumblend = 0)
opt.completeopt = "menu,menuone,noselect"
opt.pumblend = 0           -- Opaque, high-contrast, zero CPU blending overhead
opt.pumheight = 10
opt.wildmode = "longest:full,full"

--------------------------------------------------------------------------------
-- 8. Terminal UI, Folds & Aesthetics (Function over Form)
--------------------------------------------------------------------------------
opt.termguicolors = true
opt.laststatus = 3         -- Global single statusline
opt.ruler = false          -- Delegated to statusline
opt.showmode = false       -- Delegated to statusline
opt.list = true
opt.conceallevel = 2

-- Disable cursorline over SSH to eliminate horizontal redraw latency
opt.cursorline = not vim.env.SSH_CONNECTION

-- Plain ASCII folds: 100% portable on any headless or remote terminal
opt.foldlevel = 99
opt.foldmethod = "manual"  -- Prevents re-indexing lag on massive structs/JSON
opt.fillchars = {
  foldopen = "-",
  foldclose = "+",
  fold = " ",
  foldsep = " ",
  diff = "/",
  eob = " ",
}

opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }

-- In-line LSP diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})

-- Custom filetypes
vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
  },
  pattern = {
    [".*%.go%.tmpl"] = "gotmpl",
    [".*%.gotmpl"] = "gotmpl",
  },
})

--------------------------------------------------------------------------------
-- 9. Active Colorscheme & Palette Tweaks
--------------------------------------------------------------------------------
vim.cmd.colorscheme("slate")

-- Transparent background handling (must run AFTER colorscheme command)
vim.cmd.highlight({ "Normal", "guibg=none", "ctermbg=none" })
if not vim.env.SSH_CONNECTION then
  vim.cmd.highlight({ "NormalFloat", "guibg=none", "ctermbg=none" })
end
