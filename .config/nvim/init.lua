--@diagnostic disable: undefined-global
require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

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

vim.opt.rtp:prepend(lazypath)
-- Plugin setup
require('lazy').setup {
  require 'plugins.colortheme',
  require 'plugins.neo-tree',
  require 'plugins.bufferline',
  require 'plugins.lualine',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.none-ls',
  require 'plugins.autocompletion',
  require 'plugins.gitsigns',
  require 'plugins.alpha',
  require 'plugins.indent-blankline',
  require 'plugins.misc',
  require 'plugins.comment',
  require 'plugins.harpoon',
  require 'plugins.debug',
  require 'plugins.vim-tmux-navigator',
  --require 'plugins.toggleterm',
}

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

function InsertCppTemplate()
  if vim.fn.line '$' == 1 and vim.fn.getline(1) == '' then
    local templateLines = {
      '#include <bits/stdc++.h>',
      'using namespace std;',
      '',
      '#define F(i, n) for (int i = 0; i < n; i++)',
      '#define vi vector<int>',
      '#define ln long long int',
      '#define test int t; cin >> t; while (t--)',
      '#define ll long long',
      '',
      '#ifndef ONLINE_JUDGE',
      '#define debug(x) cerr << #x << " -> "; _print(x); cerr << endl',
      '#else',
      '#define debug(x)',
      '#endif',
      '',
      'void _print(int a) { cerr << a << " "; }',
      'void _print(long long a) { cerr << a << " "; }',
      'void _print(char a) { cerr << a << " "; }',
      'void _print(string a) { cerr << a << " "; }',
      'void _print(bool a) { cerr << a << " "; }',
      'template <class T, class V> void _print(pair<T, V> p) { cerr << "{"; _print(p.first); cerr << ","; _print(p.second); cerr << "}"; }',
      'template <class T> void _print(vector<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }',
      'template <class T> void _print(set<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }',
      'template <class T> void _print(multiset<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }',
      'template <class T, class V> void _print(map<T, V> v) { cerr << "[ "; for (auto i : v) { _print(i); cerr << " "; } cerr << "]"; }',
      'template <class T> void _print(pair<T, T> p) { cerr << "{"; _print(p.first); cerr << ","; _print(p.second); cerr << "}"; }',
      'template <class T, class V> void _print(multimap<T, V> v) { cerr << "[ "; for (auto i : v) { _print(i); cerr << " "; } cerr << "]"; }',
      'template <class T> void _print(unordered_set<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }',
      'template <class T> void _print(unordered_multiset<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }',
      'template <class T, class V> void _print(unordered_map<T, V> v) { cerr << "[ "; for (auto i : v) { _print(i); cerr << " "; } cerr << "]"; }',
      '',
      'void solve(){',
      '   ',
      '}',
      'int main() {',
      '#ifndef ONLINE_JUDGE',
      '    freopen("input.txt","r",stdin);',
      '    freopen("output.txt","w",stdout);',
      '    freopen("Error.txt", "w", stderr);',
      '#endif',
      '',
      'test{',
      '   solve();',
      '}',
      '',
      '    return 0;',
      '}',
    }

    -- Insert template lines
    vim.api.nvim_buf_set_lines(0, 0, -1, false, templateLines)
    vim.api.nvim_buf_set_option(0, 'modified', false)

    -- Move cursor to the line with "// Your C++ code here"
    local cursorLine = #templateLines - 13
    local cursorColumn = vim.fn.matchend(templateLines[cursorLine], '\\zs.') - 1
    vim.api.nvim_win_set_cursor(0, { cursorLine + 1, cursorColumn })

    vim.cmd 'normal! zt'
    vim.cmd 'normal! zz'
  end
end

-- Command to create a new .cpp file with the template
vim.api.nvim_exec(
  [[
  command! -nargs=1 -complete=file -bar Cpp edit <args>.cpp | lua InsertCppTemplate()
]],
  false
)

vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    if vim.bo.buftype == '' then -- only save normal buffers
      vim.cmd 'silent! write'
    end
  end,
})
