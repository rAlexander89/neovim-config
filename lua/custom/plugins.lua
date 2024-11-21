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
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    init = function()
      require("core.utils").load_mappings("dap")
    end,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.25, },
              { id = 'stacks',      size = 0.50 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'watches',     size = 0.25 },
            },
            size = 56,
            position = 'right', -- Can be "left" or "right"
          },
          {
            elements = {
              {
                id = 'repl',
                options = {
                  follow = true,
                  word_wrap = true
                },
                size = 0.70
              },
              {
                id = 'console',
                options = {
                  follow = true,
                  word_wrap = true
                },
                size = 0.30
              },
            },
            size = 12,
            position = 'bottom', -- Can be "bottom" or "top"
          },
        },
      })

      -- register Go-specific configuration
      dap.configurations.go = dap.configurations.go or {}

      -- add the custom Go debug configuration
      table.insert(dap.configurations.go,
        {
          type = "go",
          name = "CM API: Dev",
          request = "launch",
          program = ".",
          envFile = vim.fn.getcwd() .. "/.env",
          mode = "debug",
        }
      )
      table.insert(dap.configurations.go, {
        type = "go",
        name = "Fokist API: Dev",
        request = "launch",
        program = ".",
        mode = "debug"
      })

      local dapgo = require("dap-go")
      dapgo.setup({
        delve = {
          path = "dlv",
        },
      })


      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
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
