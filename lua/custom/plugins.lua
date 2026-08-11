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
        -- rust
        "rust-analyzer",
        "codelldb",                   -- debugger for rust
        -- c/c++
        "clangd",
        "clang-format",
        "cmake-language-server",

      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    version = "v2.*",  -- Pin to v2.x which supports old API
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
    "nvimtools/none-ls.nvim",  -- Community fork of null-ls, compatible with nvim 0.11+
    ft = { "go", "javascript", "javascriptreact", "typescript", "typescriptreact", "c", "cpp" },
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
      "templ",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "digitaltoad/vim-pug",
    ft = { "pug", "jade" },
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
        "templ",
        "lua",
        "tsx",        -- for react
        "typescript", -- for better js/ts support
        "regex",      -- for regex in javascript
        "markdown",   -- for jsdoc preview
        "mermaid",    -- for mermaid diagrams
        "rust",       -- for rust syntax highlighting
        "toml",       -- for Cargo.toml
        "c",          -- for c syntax highlighting
        --
        "pug",
      },
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      indent = {
        enable = true,
        -- Disable for Rust/C/C++, use cindent instead. Treesitter indents from
        -- the parse tree, so a half-typed block (an unclosed brace, a macro
        -- continuation) is an ERROR node and every new line snaps to column 0.
        -- cindent is heuristic and handles incomplete code.
        disable = { "rust", "c", "cpp" },
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
              {
                id = "scopes",
                size = 0.60,
                options = {
                  expand_lines = true,
                  indent = 2
                }
              },
              { id = 'stacks',      size = 0.30 },
              { id = 'breakpoints', size = 0.10 },
            },
            size = 56,
            position = 'right', -- Can be "left" or "right"
          },
          {
            elements = {
              {
                id = 'console',
                options = {
                  follow = true,
                  word_wrap = true
                },
                size = 1.0
              },
            },
            size = 0.3,          -- 90% of the width
            position = 'bottom', -- Can be "bottom" or "top"
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        render = {
          max_value_lines = 100, -- maximum number of value lines to display
        }
      })
      -- dapui.setup({
      --   layouts = {
      --     {
      --       elements = {
      --         { id = "scopes",      size = 0.60, },
      --         { id = 'stacks',      size = 0.30 },
      --         { id = 'breakpoints', size = 0.10 },
      --       },
      --       size = 56,
      --       position = 'right', -- Can be "left" or "right"
      --     },
      --     {
      --       elements = {
      -- {
      --   id = 'repl',
      --   options = {
      --     follow = true,
      --     word_wrap = true
      --   },
      --   size = 0.7
      -- },
      --         {
      --           id = 'console',
      --           options = {
      --             follow = true,
      --             word_wrap = true
      --           },
      --           size = 1.0
      --         },
      --       },
      --       size = 20,
      --       position = 'bottom', -- Can be "bottom" or "top"
      --     },
      --   },
      -- })

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
          console = "internalConsole",
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
        console = "internalConsole",
      })
      table.insert(dap.configurations.go, {
        type = "go",
        name = "CM API: Stg",
        request = "launch",
        program = ".",
        envFile = vim.fn.getcwd() .. "/.env",
        mode = "debug",
        args = { "-staging=true" },
        console = "internalConsole",
      })
      table.insert(dap.configurations.go, {
        type = "go",
        name = "Fokist API: Dev",
        request = "launch",
        program = "${workspaceFolder}/cmd/main.go",
        mode = "debug",
        console = "internalConsole",
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
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities

      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- Call standard on_attach to load all keybindings
            on_attach(client, bufnr)
            -- Disable inlay hints (only show types with K hover)
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })

            -- Enable real-time diagnostics for Rust
            vim.diagnostic.config({
              virtual_text = true,
              signs = true,
              update_in_insert = true, -- Show diagnostics while typing
              underline = true,
              severity_sort = true,
            })

            -- Set proper indentation for Rust
            vim.bo[bufnr].cindent = true
            vim.bo[bufnr].cinoptions = "L0,(0,Ws,J1,j1"
            vim.bo[bufnr].cinkeys = "0{,0},!^F,o,O,e"

            -- Auto-format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end,
          capabilities = capabilities,
          default_settings = {
            ['rust-analyzer'] = {
              -- If a per-project .nvim.lua has set vim.g.ra_project_root,
              -- scope rust-analyzer to that crate only. Its declared dependencies
              -- (including crates/shared) are still fully loaded.
              linkedProjects = vim.g.ra_project_root
                and { vim.g.ra_project_root .. '/Cargo.toml' }
                or nil,
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
                enable = false, -- Disable check on save since we check on type
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
                attributes = {
                  enable = true,
                },
              },
              rustfmt = {
                extraArgs = { "--config", "hard_tabs=false,tab_spaces=2" },
              },
            },
          },
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        completion = {
          cmp = {
            enabled = true,
          },
        },
      })
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    config = function()
      -- Disable default mappings, we'll use the plugin's defaults
      vim.g.tmux_navigator_no_mappings = 0
      -- Save pane on navigation
      vim.g.tmux_navigator_save_on_switch = 2
    end,
  },
}
return plugins
