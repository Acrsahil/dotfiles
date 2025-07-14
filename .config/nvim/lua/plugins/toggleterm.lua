return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    local toggleterm = require 'toggleterm'

    toggleterm.setup {
      size = 20,
      open_mapping = [[<leader>tt]],
      direction = 'float',
      float_opts = {
        border = 'rounded',
        winblend = 0,
      },
    }

    vim.api.nvim_set_keymap('t', '<esc><esc>', [[<C-\><C-n>:ToggleTermToggleAll<CR>]], { noremap = true, silent = true })
    -- In normal mode: just toggle the terminal window
    vim.api.nvim_set_keymap('n', '<esc><esc>', [[:ToggleTermToggleAll<CR>]], { noremap = true, silent = true })
  end,
}
