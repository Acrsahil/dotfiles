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

      -- ✨ ESC to quit Oil
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          vim.keymap.set('n', '<Esc>', '<Cmd>q<CR>', { buffer = true, silent = true })
        end,
      })

      -- Toggle oil with <leader>e
      vim.keymap.set('n', '<leader>e', function()
        if vim.bo.filetype == 'oil' then
          if #vim.api.nvim_tabpage_list_wins(0) > 1 then
            vim.cmd 'close'
          end

          local found_buf = nil
          local empty_buf = nil
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if
                vim.api.nvim_buf_is_loaded(buf)
                and vim.api.nvim_buf_get_option(buf, 'buflisted')
                and vim.api.nvim_buf_get_name(buf) ~= ''
                and vim.api.nvim_buf_get_option(buf, 'filetype') ~= 'oil'
            then
              found_buf = buf
            elseif
                vim.api.nvim_buf_is_loaded(buf)
                and vim.api.nvim_buf_get_option(buf, 'buflisted')
                and vim.api.nvim_buf_get_name(buf) == ''
                and vim.api.nvim_buf_get_option(buf, 'filetype') ~= 'oil'
            then
              empty_buf = buf
            end
          end

          if found_buf then
            vim.cmd('buffer ' .. found_buf)
          elseif empty_buf then
            vim.cmd('buffer ' .. empty_buf)
          else
            vim.cmd 'enew'
          end
        else
          oil.open_float()
        end
      end, { desc = 'Toggle Oil open/close with buffer fallback' })
    end,
  },
}
