return {
  'mistweaverco/kulala.nvim',
  keys = {
    { '<leader>Ks', desc = 'Send request' },
    { '<leader>Ka', desc = 'Send all requests' },
    { '<leader>Kb', desc = 'Open scratchpad' },
  },
  ft = { 'http', 'rest' },
  opts = {
    global_keymaps = true,
    global_keymaps_prefix = '<leader>K',
    kulala_keymaps_prefix = '',
  },
}
