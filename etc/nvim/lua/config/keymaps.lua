-- ~/.config/nvim/lua/config/keymaps.lua

local map = vim.keymap.set

--------------------------------------------------------------------------------
-- 1. General OS-Style Operations (Save, Select All, Quit)
--------------------------------------------------------------------------------
-- Quick Save (Ctrl+S across Normal, Insert, and Visual modes)
map({ "n", "i", "v" }, "<C-s>", "<cmd>silent! write<cr><esc>", { desc = "Save current file" })

-- Select All (Ctrl+A in Normal mode)
map("n", "<C-a>", "ggVG", { desc = "Select entire buffer" })

-- Quick exit / buffer close without killing the window split
map("n", "<leader>q", "<cmd>confirm quit<cr>", { desc = "Quit window / exit" })

--------------------------------------------------------------------------------
-- 2. Windows-Style Clipboard & Registers
--------------------------------------------------------------------------------
-- Copy / Cut to system clipboard (OSC 52 on SSH, Windows clipboard on WSL)
map("v", "<C-c>", '"+y', { desc = "Clipboard: Copy selection" })
map("v", "<C-x>", '"+d', { desc = "Clipboard: Cut selection" })

-- Paste from system clipboard (Ctrl+V)
map("n", "<C-v>", '"+p', { desc = "Clipboard: Paste after cursor" })
map("v", "<C-v>", '"+p', { desc = "Clipboard: Paste over selection" })
map("c", "<C-v>", "<C-r>+", { desc = "Clipboard: Paste into command line" })

-- Paste in Insert mode without breaking undo tree or exiting mode
map("i", "<C-v>", '<C-r><C-o>+', { desc = "Clipboard: Paste in insert mode" })

-- The classic "Don't lose my yanked text when pasting over selection"
-- Keeps the default register intact by dumping the overwritten text into the black hole (_)
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting default register" })

-- Delete into black hole (delete without cutting)
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying to register" })

--------------------------------------------------------------------------------
-- 3. Navigation: Home, End, PageUp, PageDown & Jump Ergonomics
--------------------------------------------------------------------------------
-- Home / End in Normal and Visual modes
-- <Home> goes to the first non-blank character; repeating hits the absolute column 0
map({ "n", "v" }, "<Home>", "^", { desc = "Go to line start (first character)" })
map({ "n", "v" }, "<End>", "$", { desc = "Go to line end" })

-- Home / End in Insert mode (avoids leaving insert mode to fix a line edge)
map("i", "<Home>", "<C-o>^", { desc = "Go to line start (insert mode)" })
map("i", "<End>", "<C-o>$", { desc = "Go to line end (insert mode)" })

-- Up / Down navigation on wrapped lines (moves by visual row instead of logical line)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Keep cursor perfectly centered on half-page jumps
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "<PageDown>", "<C-f>zz", { desc = "Page down and center" })
map("n", "<PageUp>", "<C-b>zz", { desc = "Page up and center" })

-- Center search results when jumping matches
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous match (centered)" })

--------------------------------------------------------------------------------
-- 4. Buffer & Window Management
--------------------------------------------------------------------------------
-- Cycle through buffers with Tab and Shift+Tab (standard browser/editor habit)
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Buffer navigation: first, last, and quick toggle
map("n", "<leader>bl", "<cmd>blast<cr>", { desc = "Buffer: Go to last buffer" })
map("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "Buffer: Go to first buffer" })
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Buffer: Switch to alternate (previous) buffer" })

-- Close current buffer safely (preserves splits using native bp|bd#)
map("n", "<leader>bd", "<cmd>bprevious | bdelete #<cr>", { desc = "Buffer: Close buffer (keep split)" })

-- Window navigation with Ctrl + Arrow keys (alternative to Ctrl+w + hjkl)
map("n", "<C-Left>", "<C-w>h", { desc = "Focus window left" })
map("n", "<C-Down>", "<C-w>j", { desc = "Focus window below" })
map("n", "<C-Up>", "<C-w>k", { desc = "Focus window above" })
map("n", "<C-Right>", "<C-w>l", { desc = "Focus window right" })

-- Resize splits using Alt + Arrow keys
map("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

--------------------------------------------------------------------------------
-- 5. Text Editing Shortcuts & Quality-of-Life Gems
--------------------------------------------------------------------------------
-- Windows-style Shift + Arrow selection from Normal mode
map("n", "<S-Up>", "v<Up>", { desc = "Select text up" })
map("n", "<S-Down>", "v<Down>", { desc = "Select text down" })
map("n", "<S-Left>", "v<Left>", { desc = "Select text left" })
map("n", "<S-Right>", "v<Right>", { desc = "Select text right" })

-- Expand selection with Shift + Arrows inside Visual mode
map("v", "<S-Up>", "<Up>", { desc = "Expand selection up" })
map("v", "<S-Down>", "<Down>", { desc = "Expand selection down" })
map("v", "<S-Left>", "<Left>", { desc = "Expand selection left" })
map("v", "<S-Right>", "<Right>", { desc = "Expand selection right" })

-- Start selection from Insert mode directly
map("i", "<S-Up>", "<Esc>v<Up>", { desc = "Start selection up (insert mode)" })
map("i", "<S-Down>", "<Esc>v<Down>", { desc = "Start selection down (insert mode)" })
map("i", "<S-Left>", "<Esc>v<Left>", { desc = "Start selection left (insert mode)" })
map("i", "<S-Right>", "<Esc>v<Right>", { desc = "Start selection right (insert mode)" })

-- Move selected lines up/down in Visual mode (like Alt+Up/Down in VS Code / JetBrains)
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })

-- Keep visual selection active when indenting with < and >
map("v", "<", "<gv", { desc = "Un-indent selection and re-select" })
map("v", ">", ">gv", { desc = "Indent selection and re-select" })

-- Clear search highlight with Escape
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Join lines without moving cursor to the end of the joined line
map("n", "J", "mzJ`z", { desc = "Join line below and preserve cursor position" })

--------------------------------------------------------------------------------
-- 6. Floating Terminal (Pure Neovim API - Zero external dependencies)
--------------------------------------------------------------------------------
local term_buf = nil
local term_win = nil

local function toggle_floating_terminal()
  -- If window is open and valid, close it (hide without killing process)
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, false)
    term_win = nil
    return
  end

  -- Create buffer if it does not exist or was deleted
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
  end

  -- Dimensions: 85% width, 80% height, centered on screen
  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.80)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  term_win = vim.api.nvim_open_win(term_buf, true, win_opts)

  -- Spawn shell job inside buffer only if it hasn't spawned yet
  if vim.bo[term_buf].buftype ~= "terminal" then
    vim.fn.jobstart(vim.o.shell, {
      term = true,
      on_exit = function()
        if term_win and vim.api.nvim_win_is_valid(term_win) then
          vim.api.nvim_win_close(term_win, false)
        end
        term_win = nil
        term_buf = nil
      end,
    })
  end

  -- Enter terminal insert mode immediately upon opening
  vim.cmd("startinsert")
end

-- Keymaps to toggle terminal
map({ "n", "t" }, "<C-'>", toggle_floating_terminal, { desc = "Terminal: Toggle floating terminal" })
map({ "n", "t" }, "<leader>tt", toggle_floating_terminal, { desc = "Terminal: Toggle floating terminal" })

-- Double Escape to exit terminal insert mode back to Normal mode (to copy text, navigate, etc.)
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal: Exit to normal mode" })

-- Direct window switching out of terminal mode
map("t", "<C-Left>", [[<C-\><C-n><C-w>h]], { desc = "Terminal: Focus window left" })
map("t", "<C-Down>", [[<C-\><C-n><C-w>j]], { desc = "Terminal: Focus window below" })
map("t", "<C-Up>", [[<C-\><C-n><C-w>k]], { desc = "Terminal: Focus window above" })
map("t", "<C-Right>", [[<C-\><C-n><C-w>l]], { desc = "Terminal: Focus window right" })

