-- ~/.config/nvim/lua/plugins/init.lua

return {
  -----------------------------------------------------------------------------
  -- 1. Tree-sitter (Precise AST syntax parsing & folding)
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then
        ok, ts = pcall(require, "nvim-treesitter.config")
      end

      if ok and ts and ts.setup then
        ts.setup({
          ensure_installed = { "go", "python", "zig", "lua", "sql" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- 2. File Navigation: Oil.nvim (Buffer-driven text operations)
  -----------------------------------------------------------------------------
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = true,
      columns = { "permissions", "size", "mtime" },
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { "-",
        function()
          require("oil").open_float()
        end,
        desc = "Open parent directory (Oil float)",
      },
    },
    float = {
      padding = 5,
      max_width = 0.9,
      max_height = 0.9,
      border = "rounded",
    },
  },

  -----------------------------------------------------------------------------
  -- 3. High-Speed Utilities: mini.nvim (Pick, Statusline, Diff, Surround, AI)
  -----------------------------------------------------------------------------
  {
    "nvim-mini/mini.nvim",
    version = false,
    event = "VeryLazy",
    keys = {
      {
        "<leader>ff",
        function()
          require("mini.pick").builtin.files()
        end,
        desc = "Find files (mini.pick)",
      },
      {
        "<leader>fg",
        function()
          require("mini.pick").builtin.grep_live()
        end,
        desc = "Live grep (mini.pick)",
      },
      {
        "<leader>fb",
        function()
          require("mini.pick").builtin.buffers()
        end,
        desc = "Find open buffers (mini.pick)",
      },
    },
    config = function()
      -- Minimalist fuzzy finder: zero redraw lag over SSH
      require("mini.pick").setup({
        window = {
          config = {
            border = "rounded",
          },
        },
      })

      -- Ultra-fast native statusline: plain text, high informational density
      require("mini.statusline").setup({
        set_vim_settings = false, -- Respects opt.laststatus = 3
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git           = MiniStatusline.section_git({ trunc_width = 75 })
            local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location      = MiniStatusline.section_location({ trunc_width = 75 })

            -- Display explicit [SSH] tag when working on remote servers
            local ssh = vim.env.SSH_CONNECTION and "[SSH] " or ""

            return MiniStatusline.combine_groups({
              { hl = mode_hl,                  strings = { mode } },
              { hl = "MiniStatuslineDevinfo",   strings = { ssh, git, diagnostics } },
              "%<", -- Truncation point
              { hl = "MiniStatuslineFilename",  strings = { filename } },
              "%=", -- Right alignment separator
              { hl = "MiniStatuslineFileinfo",  strings = { fileinfo } },
              { hl = mode_hl,                  strings = { location } },
            })
          end,
        },
      })

      -- Git diff signs in signcolumn with zero overhead
      require("mini.diff").setup({
        view = {
          style = "sign",
          signs = { add = "+", change = "~", delete = "-" },
        },
      })

      -- Fast delimiter handling: sa (add), sd (delete), sr (replace)
      require("mini.surround").setup()

      -- Extended text objects: 'va)' (around args), 'vif' (inside function)
      require("mini.ai").setup()

      require("mini.files").setup()
    end,
  },

  -----------------------------------------------------------------------------
  -- 4. LSP Client Architecture (gopls, pyright, zls)
  -----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "pyright", "zls" },
      })

      local servers = { "gopls", "pyright", "zls" }

      -- Native Neovim 0.11+ API initialization
      if vim.lsp.config and vim.lsp.enable then
        for _, server in ipairs(servers) do
          vim.lsp.config[server] = {}
          vim.lsp.enable(server)
        end
      else
        -- Neovim <= 0.10 fallback
        local lspconfig = require("lspconfig")
        for _, server in ipairs(servers) do
          lspconfig[server].setup({})
        end
      end

      -- Attach keymaps conditionally upon LSP handshake
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
          map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to implementation")
          map("n", "gr", vim.lsp.buf.references, "LSP: Show references")
          map("n", "K", vim.lsp.buf.hover, "LSP: Documentation / hover")
          map("n", "<leader>cr", vim.lsp.buf.rename, "LSP: Rename symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
          map("n", "[d", vim.diagnostic.goto_prev, "Diagnostic: Previous error/warn")
          map("n", "]d", vim.diagnostic.goto_next, "Diagnostic: Next error/warn")
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- 5. Completion Engine: blink.cmp (Rust-backed, instant response)
  -----------------------------------------------------------------------------
    
  --[[
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "default", -- <C-space> to open, <CR> to accept, <Tab>/<S-Tab> to cycle
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
  ]]--
  -- Enable third-party plugin to define the `rose-pine` color scheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = true,
  },
}
