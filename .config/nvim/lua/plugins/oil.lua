return {
  {
    'stevearc/oil.nvim',
    dependencies = { { 'echasnovski/mini.icons' } },
    lazy = false,
    config = function()
      local oil = require 'oil'

      oil.setup {
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          is_always_visible = function(name)
            return name == '..'
          end,
        },
        float = {
          padding = 2,
          max_width = 80,
          max_height = 40,
          border = 'rounded',
          title = function()
            local cwd = vim.fn.expand '%:p:h:t'
            return '󰉋  ' .. cwd .. ' (..)'
          end,
          title_pos = 'center',
        },
      }

      -- ESC to quit Oil
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          vim.keymap.set('n', '<Esc>', '<Cmd>q<CR>', { buffer = true, silent = true })
        end,
      })

      -- Keep track of last non-Oil buffer
      local last_file_buf = nil

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        callback = function()
          if vim.bo.filetype ~= 'oil' then
            last_file_buf = vim.api.nvim_get_current_buf()
          end
        end,
      })

      -- Toggle Oil
      vim.keymap.set('n', '<leader>e', function()
        if vim.bo.filetype == 'oil' then
          vim.cmd 'close'
          if last_file_buf and vim.api.nvim_buf_is_valid(last_file_buf) then
            vim.api.nvim_set_current_buf(last_file_buf)
          end
        else
          oil.open_float()
        end
      end, { desc = 'Toggle Oil without switching files' })
    end,
  },
}
