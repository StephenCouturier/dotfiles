-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = '[F]ind [R]ecently opened files' })
      vim.keymap.set('n', '<leader>fl', require('telescope.builtin').resume, { desc = '[F]ind [L]ast search' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[F]ind existing [B]uffers' })
      vim.keymap.set('n', '<leader>fc', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[F]uzzily search in [C]urrent buffer' })

      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = '[F]ind [G]it Files' })
      vim.keymap.set('n', '<leader>ff',
        ":lua require('telescope.builtin').find_files { find_command = { 'rg', '--files', '-g', '!**/*.test.*', '-g', '!**/*.spec.*' } }<CR>",
        { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>ft',
        ":lua require('telescope.builtin').find_files { find_command = { 'rg', '--files', '-g', '**/*.test.*', '-g', '**/*.spec.*' } }<CR>",
        { desc = '[F]ind [T]ests' })
      vim.keymap.set('n', '<leader>faf',
        ":lua require('telescope.builtin').find_files { find_command = { 'rg', '--files', '-uu','-g', '!**/node_modules/**' } }<CR>",
        { desc = '[F]ind [A]ll [F]iles', })
      vim.keymap.set('n', '<leader>faw',
        ":lua require('telescope.builtin').live_grep { }<CR>",
        { desc = '[F]ind [A]ll [W]ords', })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>*', require('telescope.builtin').grep_string, { desc = '[*] Find current word' })
      vim.keymap.set('n', '<leader>fw',
        ":lua require('telescope.builtin').live_grep { glob_pattern = {'!**/*.spec.*', '!**/*.test.*'} }<CR>",
        { desc = '[F]ind [W]ord in Files' })
      vim.keymap.set('n', '<leader>fW',
        ":lua require('telescope.builtin').live_grep { glob_pattern = {'**/*.spec.*', '**/*.test.*'} }<CR>",
        { desc = '[F]ind [W]ord in Tests' })
      vim.keymap.set('n', '<leader>fq',
        ":lua require('telescope.builtin').live_grep { glob_pattern = {'**/*.queries.*', '**/schema/**' } }<CR>",
        { desc = '[F]ind Word in Frontend [Q]ueries' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
