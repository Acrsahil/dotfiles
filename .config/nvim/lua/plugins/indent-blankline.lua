return {
  {
    'echasnovski/mini.indentscope',
    version = false,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local indentscope = require 'mini.indentscope'

      indentscope.setup {
        symbol = '│', -- continuous line
        draw = {
          delay = 20, -- faster redraw
          animation = indentscope.gen_animation.quadratic {
            easing = 'out',
            duration = 15, -- faster animation
          },
        },
      }

      -- disable in certain filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'help', 'dashboard', 'NvimTree', 'Trouble' },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })

      -- 💙 Set indent line color (blue)
      vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#5EA9FF', nocombine = true })
    end,
  },
}
