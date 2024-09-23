-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>go', ":GBrowse<CR>", { desc = "Open Remote" })

vim.keymap.set('n', '<leader>q', ":q<CR>", { desc = "[Q]uit nvim" })
vim.keymap.set('n', '<leader>Q', ":q!<CR>", { desc = "Force [Q]uit nvim" })
vim.keymap.set('n', '<leader>w', ":w<CR>", { desc = "[W]rite file" })
vim.keymap.set('n', '<leader>W', ":wa<CR>", { desc = "[W]rite [A]ll files" })
vim.keymap.set('n', '<leader>x', ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set('n', '<leader>X', ":bd!<CR>", { desc = "Force Close buffer" })
vim.keymap.set('n', '<leader>bc', ":%bd|e#<CR>", { desc = "Close all buffers but current" })
vim.keymap.set('n', '<leader>ba', ":%bd|e#<CR>", { desc = "Close all buffers " })
vim.keymap.set('n', '<leader>br', ":bufdo e<CR>", { desc = "[R]efresh buffers" })

vim.keymap.set('n', '<leader>u', ":UndotreeToggle<CR>", { desc = "[U]ndotree toggle" })

vim.keymap.set('n', '<leader>ha', ":lua require('harpoon.mark').add_file()<CR>")
vim.keymap.set('n', '<leader>hh', ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
vim.keymap.set('n', '<leader>hn', ":lua require('harpoon.ui').nav_next()<CR>")
vim.keymap.set('n', '<leader>hp', ":lua require('harpoon.ui').nav_prev()<CR>")
vim.keymap.set('n', '<leader>hj', ":lua require('harpoon.ui').nav_file(1)<CR>")
vim.keymap.set('n', '<leader>hk', ":lua require('harpoon.ui').nav_file(2)<CR>")
vim.keymap.set('n', '<leader>hl', ":lua require('harpoon.ui').nav_file(3)<CR>")
vim.keymap.set('n', '<leader>hm', ":lua require('harpoon.ui').nav_file(4)<CR>")

vim.keymap.set('n', '<leader>y', "gg^vG$y")

vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Open floating [L]sp [D]iagnostic message' })
vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Basic Autocommands ]] See `:help lua-guide-autocommands`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
