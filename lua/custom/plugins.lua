local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- good stuff
        "gopls",
        "html-lsp",
        "css-lsp",
        "html-lsp",
        "css-lsp",
        "templ",
        -- deal with the devil
        "typescript-language-server", -- typescript/javascript lsp
        "eslint-lsp",                 -- javascript linter
        "prettier",                   -- formatter
        "json-lsp",

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
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "javascript",
        "jsdoc",
        "html",
        "css",
        "json",
        "go",
        "gomod",
        "lua",
        "tsx",        -- for react
        "typescript", -- for better js/ts support
        "regex",      -- for regex in javascript
        "markdown",   -- for jsdoc preview
      },
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      indent = {
        enable = true,
      },
      incrcmental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          node_decremental = "<BS>",
          scope_incremental = "<TAB>",
        },
      },
    },
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
    "nvim-telescope/telescope.nvim",
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
            },
          }
        }
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
              { id = "scopes",      size = 0.60, },
              { id = 'stacks',      size = 0.30 },
              { id = 'breakpoints', size = 0.10 },
            },
            size = 56,
            position = 'right', -- Can be "left" or "right"
          },
          {
            elements = {
              -- {
              --   id = 'repl',
              --   options = {
              --     follow = true,
              --     word_wrap = true
              --   },
              --   size = 0.70
              -- },
              {
                id = 'console',
                options = {
                  follow = true,
                  word_wrap = true
                },
                size = 1.0
              },
            },
            size = 20,
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
        name = "CM API: Prod",
        request = "launch",
        program = ".",
        envFile = vim.fn.getcwd() .. "/.env",
        mode = "debug",
        args = { "-production=true" },
      })
      table.insert(dap.configurations.go, {
        type = "go",
        name = "CM API: Stg",
        request = "launch",
        program = ".",
        envFile = vim.fn.getcwd() .. "/.env",
        mode = "debug",
        args = { "-staging=true" },
      })
      table.insert(dap.configurations.go, {
        type = "go",
        name = "Fokist API: Dev",
        request = "launch",
        program = "${workspaceFolder}/cmd/main.go",
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
        delay = 100,
        filetypes_denylist = {
          "NvimTree",
          "lazy",
          "neogitstatus",
          "Trouble",
          "TelescopePrompt",
        },
        modes_allowlist = { 'n' },
        providers_regex_syntax_denylist = {},
      })
    end
  },
}
return plugins
