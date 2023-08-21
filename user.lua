return {
        -- Configure AstroNvim updates
        updater = {
                remote = "origin",     -- remote to use
                channel = "stable",    -- "stable" or "nightly"
                version = "latest",    -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
                branch = "nightly",    -- branch name (NIGHTLY ONLY)
                commit = nil,          -- commit hash (NIGHTLY ONLY)
                pin_plugins = nil,     -- nil, true, false (nil will pin plugins on stable only)
                skip_prompts = false,  -- skip prompts about breaking changes
                show_changelog = true, -- show the changelog after performing an update
                auto_quit = false,     -- automatically quit the current session after a successful update
                remotes = {            -- easily add new remotes to track
                        --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
                        --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
                        --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
                },
        },

        plugins = {
                { "ellisonleao/gruvbox.nvim" },
                { "nvim-treesitter/nvim-treesitter" },
                { "nvim-lua/plenary.nvim" },
                { "ThePrimeagen/harpoon" },
                { 'wellle/context.vim' },
                {"zbirenbaum/copilot.lua" ,
                        cmd = "Copilot",
                          event = "InsertEnter",
                          config = function()
                            require("copilot").setup({
                                panel = {
                                    enabled = true,
                                    auto_refresh = false,
                                    keymap = {
                                      jump_prev = "[[",
                                      jump_next = "]]",
                                      accept = "<CR>",
                                      refresh = "gr",
                                      open = "<M-CR>"
                                    },
                                    layout = {
                                      position = "bottom", -- | top | left | right
                                      ratio = 0.4
                                    },
                                  },
                                  suggestion = {
                                    enabled = true,
                                    auto_trigger = true,
                                    debounce = 75,
                                    keymap = {
                                      accept = "<C-CR>",
                                      accept_word = false,
                                      accept_line = false,
                                      next = "<C-n>",
                                      prev = "<C-N>",
                                      dismiss = "<C-x>",
                                    },
                                  },
                                  filetypes = {
                                    yaml = false,
                                    markdown = false,
                                    help = false,
                                    gitcommit = false,
                                    gitrebase = false,
                                    hgcommit = false,
                                    svn = false,
                                    cvs = false,
                                    ["."] = false,
                                  },
                                  copilot_node_command = 'node', -- Node.js version must be > 16.x
                                  server_opts_overrides = {},
                                })
                          end,
                },
                {"tyru/open-browser.vim", lazy= false},
                {"tyru/open-browser-github.vim", lazy = false},

                { "mbbill/undotree", lazy = false },
                {
                        "onsails/lspkind.nvim",
                        opts = function(_, opts)
                                -- use codicons preset
                                opts.preset = "codicons"
                                -- set some missing symbol types
                                opts.symbol_map = {
                                        Array = "",
                                        Boolean = "",
                                        Key = "",
                                        Namespace = "",
                                        Null = "",
                                        Number = "",
                                        Object = "",
                                        Package = "",
                                        String = "",
                                }
                                return opts
                        end,
                },
                {
                    "ggandor/leap.nvim",
                    keys = {
                      { "s", "<Plug>(leap-forward-to)", mode = { "n", "x", "o" }, desc = "Leap forward to" },
                      { "S", "<Plug>(leap-backward-to)", mode = { "n", "x", "o" }, desc = "Leap backward to" },
                      { "x", "<Plug>(leap-forward-till)", mode = { "x", "o" }, desc = "Leap forward till" },
                      { "X", "<Plug>(leap-backward-till)", mode = { "x", "o" }, desc = "Leap backward till" },
                      { "gs", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "Leap from window" },
                    },
                    opts = {},
                    init = function() -- https://github.com/ggandor/leap.nvim/issues/70#issuecomment-1521177534
                      vim.api.nvim_create_autocmd("User", {
                        callback = function()
                          vim.cmd.hi("Cursor", "blend=100")
                          vim.opt.guicursor:append { "a:Cursor/lCursor" }
                        end,
                        pattern = "LeapEnter",
                      })
                      vim.api.nvim_create_autocmd("User", {
                        callback = function()
                          vim.cmd.hi("Cursor", "blend=0")
                          vim.opt.guicursor:remove { "a:Cursor/lCursor" }
                        end,
                        pattern = "LeapLeave",
                      })
                    end,
                    dependencies = {
                      "tpope/vim-repeat",
                    },
                  },

        },

        mappings = {
                n = {
                        ["<C-u>"] = { "<C-u>zz" },
                        ["<C-d>"] = { "<C-d>zz" },
                        ["<S-h>"] = { ":bprev<CR>"},
                        ["<S-l>"] = { ":bnext<CR>"},
                        ["<leader>z"] = { ":UndotreeToggle<CR>" },
                        ["<leader>go"] = { ":OpenGithubFile<CR>" },
                        ["<leader>mh"] = { ":lua require('harpoon.mark').add_file()<CR>" },
                        ["<leader>mm"] = { ":lua require('harpoon.ui').toggle_quick_menu()<CR>" },
                        ["<leader>mn"] = { ":lua require('harpoon.ui').nav_next()<CR>" },
                        ["<leader>mN"] = { ":lua require('harpoon.ui').nav_prev()<CR>" },
                        ["<leader>mj"] = { ":lua require('harpoon.ui').nav_file(0)<CR>" },
                        ["<leader>mk"] = { ":lua require('harpoon.ui').nav_file(1)<CR>" },
                        ["<leader>ml"] = { ":lua require('harpoon.ui').nav_file(2)<CR>" },
                        ["<leader>mr"] = { ":lua require('harpoon.ui').nav_file(3)<CR>" }

                },
        },

        -- set up UI icons
        icons = {
                ActiveLSP = "",
                ActiveTS = " ",
                BufferClose = "",
                DapBreakpoint = "",
                DapBreakpointCondition = "",
                DapBreakpointRejected = "",
                DapLogPoint = "",
                DapStopped = "",
                DefaultFile = "",
                Diagnostic = "",
                DiagnosticError = "",
                DiagnosticHint = "",
                DiagnosticInfo = "",
                DiagnosticWarn = "",
                Ellipsis = "",
                FileModified = "",
                FileReadOnly = "",
                FoldClosed = "",
                FoldOpened = "",
                FolderClosed = "",
                FolderEmpty = "",
                FolderOpen = "",
                Git = "",
                GitAdd = "",
                GitBranch = "",
                GitChange = "",
                GitConflict = "",
                GitDelete = "",
                GitIgnored = "",
                GitRenamed = "",
                GitStaged = "",
                GitUnstaged = "",
                GitUntracked = "",
                LSPLoaded = "",
                LSPLoading1 = "",
                LSPLoading2 = "",
                LSPLoading3 = "",
                MacroRecording = "",
                Paste = "",
                Search = "",
                Selected = "",
                TabClose = "",
        },

        -- Set colorscheme to use
        colorscheme = "gruvbox",

        -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
        diagnostics = {
                virtual_text = true,
                underline = true,
        },

        lsp = {
                -- customize lsp formatting options
                formatting = {
                        -- control auto formatting on save
                        format_on_save = {
                                enabled = true,     -- enable or disable format on save globally
                                allow_filetypes = { -- enable format on save for specified filetypes only
                                        -- "go",
                                },
                                ignore_filetypes = { -- disable format on save for specified filetypes
                                        -- "python",
                                },
                        },
                        disabled = { -- disable formatting capabilities for the listed language servers
                                -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
                                -- "lua_ls",
                        },
                        timeout_ms = 1000, -- default format timeout
                        -- filter = function(client) -- fully override the default formatting function
                        --   return true
                        -- end
                },
                -- enable servers that you already have installed without mason
                servers = {
                        -- "pyright"
                },
        },

        -- Configure require("lazy").setup() options
        lazy = {
                defaults = { lazy = true },
                performance = {
                        rtp = {
                                -- customize default disabled vim plugins
                                disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
                        },
                },
        },

        -- This function is run last and is a good place to configuring
        -- augroups/autocommands and custom filetypes also this just pure lua so
        -- anything that doesn't fit in the normal config locations above can go here
        polish = function()
                -- Set up custom filetypes
                -- vim.filetype.add {
                --   extension = {
                --     foo = "fooscript",
                --   },
                --   filename = {
                --     ["Foofile"] = "fooscript",
                --   },
                --   pattern = {
                --     ["~/%.config/foo/.*"] = "fooscript",
                --   },
                -- }
        end,
}
