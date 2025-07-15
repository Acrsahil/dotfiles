-- plugins/yankvisual.lua

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
      vim.highlight.on_yank {
        higroup = 'IncSearch',
        timeout = 150,
      }
    end,
    desc = 'Highlight yanked text briefly',
  })
end

return M
