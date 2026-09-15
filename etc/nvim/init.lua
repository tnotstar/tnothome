-- ~/.config/nvim/init.lua

-- 1. Load baseline options & keymaps before plugins to ensure leader keys and runtimes are set
require("config.options")
require("config.keymaps")

-- 2. Bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    repo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "None" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 3. Configure lazy.nvim with headless/remote performance constraints
require("lazy").setup("plugins", {
  defaults = {
    lazy = true, -- Lazy-load plugins by default unless explicitly specified
  },
  install = {
    colorscheme = { "slate" }, -- Resilient built-in fallback colorscheme
  },
  checker = {
    enabled = false, -- Never poll GitHub automatically in the background
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false, -- Reload changes without spawning popup notifications
  },
  ui = {
    border = "rounded",
    -- Fallback to standard Unicode characters to avoid broken glyphs over plain SSH
    icons = {
      cmd = ">",
      config = "*",
      event = "~",
      ft = "F",
      init = "I",
      keys = "K",
      plugin = "P",
      runtime = "R",
      require = "r",
      source = "S",
      start = "+",
      task = "[v]",
      lazy = "zZ",
    },
  },
  performance = {
    rtp = {
      -- Completely unload legacy built-in Vim plugins from runtimepath
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
