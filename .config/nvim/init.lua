--@diagnostic disable: undefined-global

require 'core.keymaps' -- Load general keymaps
require 'core.options'

-- Enable line numbers and hybrid mode by default
-- Temporary fix for telescope treesitter issue
vim.g.telescope_disable_ts_highlighter = 1

vim.opt.showtabline = 0
vim.opt.number = true
vim.opt.relativenumber = true

-- Auto toggle relativenumber on InsertEnter and InsertLeave
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  callback = function()
    vim.wo.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  callback = function()
    vim.wo.relativenumber = true
  end,
})

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)
-- Plugin setup
require('lazy').setup {
  require 'plugins.treesitter',
  require 'plugins.colortheme',
  --require 'plugins.neo-tree',
  --require 'plugins.bufferline',

  require 'plugins.ai',
  require 'plugins.django',
  require 'plugins.lualine',
  require 'plugins.dadbod',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.none-ls',
  require 'plugins.autocompletion',
  require 'plugins.gitsigns',
  require 'plugins.alpha',
  require 'plugins.indent-blankline',
  require 'plugins.misc',
  require 'plugins.comment',
  require 'plugins.debug',
  require 'plugins.vim-tmux-navigator',
  require 'plugins.flutter',
  --require 'plugins.toggleterm',
  require 'plugins.yazi',
  require 'plugins.oil',
  require 'plugins.numbertoggle',
  require 'plugins.vimbe',
  require 'plugins.harpoon',
  require('plugins.yankvisual').setup(),
}
require 'config'

vim.cmd [[
  augroup run_file
    autocmd!
    autocmd BufEnter *.py let @k=":w\<CR>:vsp | terminal python %\<CR>i"
    autocmd BufEnter *.java let @k=":w\<CR>:vsp | terminal java %\<CR>i"
    autocmd BufEnter *.asm let @k=":w\<CR>:!nasm -f elf64 -o out.o % && ld out.o -o a.out && ./a.out\<CR>| :vsp | terminal<CR>i"
    autocmd BufEnter *.cpp let @k=":w\<CR> :!g++ %\<CR> | :vsp | terminal ./a.out\<CR>i"
    autocmd BufEnter *.c let @k=":w\<CR>:!gcc % -o a.out && ./a.out\<CR>| :vsp | terminal<CR>i"
    autocmd BufEnter *.go let @k=":w\<CR>:vsp | terminal go run %\<CR>i"
    autocmd BufEnter *.js let @k=":w\<CR>:vsp | terminal node %\<CR>i"
    autocmd BufEnter *.html let @k=":w\<CR>:silent !chromium % \<CR>"
  augroup END
]]

-- Setup catppuccin with highlight overrides
require('catppuccin').setup {
  flavour = 'mocha', -- or "latte", "frappe", "macchiato"
  transparent_background = false, -- set true if you use transparency
  term_colors = true,
  integrations = {
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { 'undercurl' },
        hints = { 'undercurl' },
        warnings = { 'undercurl' },
        information = { 'undercurl' },
      },
    },
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    telescope = true,
    notify = false,
    mini = false,
  },
  custom_highlights = function(colors)
    return {
      -- Line numbers
      LineNr = { fg = colors.text }, -- Normal line number (peach)
      CursorLineNr = { fg = colors.blue, bold = true }, -- Current line number (bright blue)

      -- Cursor line background
      CursorLine = { bg = colors.surface0 }, -- Subtle blueish background

      -- Optional: make sign column (like git diff marks) look consistent
      SignColumn = { bg = colors.base },

      -- Optional: Match fold column color too
      FoldColumn = { fg = colors.overlay0, bg = colors.base },
    }
  end,
}

-- Apply the colorscheme
vim.cmd.colorscheme 'catppuccin'

-- Set line numbers and cursor line
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.api.nvim_set_hl(0, 'AutosaveMsg', { fg = '#00FF5F' }) -- nice neon green

vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    if vim.bo.buftype == '' and vim.bo.modified then
      vim.cmd 'silent! write'

      local filename = vim.fn.expand '%:t'
      local message = '✓ ' .. filename .. ' saved successfully '

      vim.cmd('echohl AutosaveMsg | echo "' .. message .. '" | echohl None')

      vim.defer_fn(function()
        vim.cmd "echo ''"
      end, 1500)
    end
  end,
})

vim.keymap.set('n', '<C-t>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')
vim.keymap.set('n', '<M-a>', '<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>')
vim.keymap.set('n', '<M-s>', '<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>')
vim.keymap.set('n', '<M-f>', '<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>')
vim.keymap.set('n', '<M-g>', '<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>')
vim.keymap.set('n', '<leader>du', ':DBUIToggle<CR>', { desc = 'Toggle DB UI' })
vim.keymap.set('n', '<leader>df', ':DBUIFindBuffer<CR>', { desc = 'Find DB buffer' })
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.dart',
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.dart',
  callback = function()
    -- Check if Flutter tools client is attached
    for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
      if client.name == 'dartls' then
        vim.cmd 'FlutterReload'
        break
      end
    end
  end,
})

local api = vim.api

local function safe_harpoon_select(index)
  local win = api.nvim_get_current_win()
  local winfixbuf = vim.wo.winfixbuf
  if winfixbuf then
    vim.wo.winfixbuf = false
  end

  require('harpoon.ui').nav_file(index)

  if winfixbuf then
    vim.wo.winfixbuf = true
  end
end
