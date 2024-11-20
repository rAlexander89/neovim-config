local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        -- "html",
        -- "htmx",
        -- "tailwindcss",
        -- "typescript-language-server",

      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = "go",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "nvim-telescope/telescope.nvim"
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require('treesitter-context').setup {
        enable = true,
        max_lines = 0,        -- Set to 0 to show all lines
        trim_scope = 'outer', -- Hide lines for other scopes
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require('treesitter-context').setup {
        enable = true,
        max_lines = 0,        -- Set to 0 to show all lines
        trim_scope = 'outer', -- Hide lines for other scopes
      }
    end,
  },
  {
    "RRethy/vim-illuminate",
    lazy = false,
    config = function()
      require('illuminate').configure({
        -- delay: delay in milliseconds
        delay = 100,
        -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
        filetypes_denylist = {
          "NvimTree",
          "lazy",
          "neogitstatus",
          "Trouble",
          "TelescopePrompt",
        },
        -- modes_allowlist: modes to illuminate in
        modes_allowlist = { 'n' },
        -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_denylist = {},
      })
    end
  },
}
return plugins
