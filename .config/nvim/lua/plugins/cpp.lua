-- File: ~/.config/nvim/lua/utils/cpptemplate.lua
local M = {}

M.insert_cpp_template_and_add_harpoon = function()
  local harpoon = require 'harpoon'
  local list = harpoon:list()

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

    vim.api.nvim_buf_set_lines(0, 0, -1, false, templateLines)
    vim.api.nvim_buf_set_option(0, 'modified', false)

    local cursorLine = #templateLines - 13
    local cursorColumn = vim.fn.matchend(templateLines[cursorLine], '\\zs.') - 1
    vim.api.nvim_win_set_cursor(0, { cursorLine + 1, cursorColumn })
    vim.cmd 'normal! zt'
    vim.cmd 'normal! zz'
  end

  -- Add to Harpoon index 1
  local filepath = vim.api.nvim_buf_get_name(0)
  local filename = vim.fn.expand '%:t'

  list.items[1] = { value = filepath, display = filename }
  if list.sync then
    list:sync()
  end
end

return M
