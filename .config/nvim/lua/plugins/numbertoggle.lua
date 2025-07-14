---@type LazySpec
return {
  'nvim-lua/plenary.nvim', -- dummy dependency to keep structure; replace or remove if needed
  lazy = false,
  config = function()
    -- Enable number and relativenumber
    vim.opt.number = true
    vim.opt.relativenumber = true

    -- Autocmds to toggle relativenumber in insert mode
    vim.api.nvim_create_autocmd('InsertEnter', {
      callback = function()
        vim.wo.relativenumber = false
      end,
    })

    vim.api.nvim_create_autocmd('InsertLeave', {
      callback = function()
        vim.wo.relativenumber = true
      end,
    })
  end,
}
