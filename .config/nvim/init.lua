require "core"
-- Set the leader key to " "

vim.opt.shada = ""

vim.cmd('set autoread')
vim.cmd('autocmd CursorHold * checktime')


-- Automatically reload the current file when it changes on disk on nvim
-- vim.api.nvim_exec([[
--   augroup AutoReload
--     autocmd!
--     autocmd BufWritePost * :checktime
--   augroup END
-- ]], false)
--

-- Automatically reloads tmux plane
vim.api.nvim_exec([[
  augroup AutoReloadTmux
    autocmd!
    autocmd BufWritePost * :silent !tmux send-keys -t 0.1 'C-l' \| tmux send-keys -t 0.1 ':e %' Enter
  augroup END
]], false)





-- Automatically save the buffer when leaving Insert mode

vim.cmd([[
  augroup AutoSaveOnLeaveInsert
    autocmd!
    autocmd InsertLeave * :w
  augroup END
]])


vim.o.swapfile = false

-- Set relative line numbers
vim.cmd[[set relativenumber]]



vim.g.python3_host_prog = '/home/window/.config/nvim/env/neovim/bin/python3'
vim.g.loaded_python3_provider = 1


vim.api.nvim_set_var("mapleader", " ")

vim.cmd([[
  let @r=':%s/\\<C-r>"//g\<Left>\<Left>'
]])

vim.cmd([[
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
]])

function InsertCppTemplate()
  if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
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
          '}'
      }

      -- Insert template lines
      vim.api.nvim_buf_set_lines(0, 0, -1, false, templateLines)
      vim.api.nvim_buf_set_option(0, 'modified', false)

      -- Move cursor to the line with "// Your C++ code here"
      local cursorLine = #templateLines - 13
      local cursorColumn = vim.fn.matchend(templateLines[cursorLine], '\\zs.') - 1
      vim.api.nvim_win_set_cursor(0, {cursorLine + 1, cursorColumn})

    vim.cmd('normal! zt')
  vim.cmd('normal! zz')
  end
end

-- Command to create a new .cpp file with the template
vim.api.nvim_exec([[
  command! -nargs=1 -complete=file -bar Cpp edit <args>.cpp | lua InsertCppTemplate()
]], false)






--below is the previous code
local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"
