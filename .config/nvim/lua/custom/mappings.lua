local M = {}

-- Debugging keybindings for nvim-dap
M.dap = {
  plugin = true,
  n = {
    -- Toggle breakpoint
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },

    -- Start or continue the debugger
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start or continue the debugger",
    },

    -- Step over code
    ["<leader>do"] = {
      "<cmd> DapStepOver <CR>",
      "Step over",
    },

    -- Step into code
    ["<leader>di"] = {
      "<cmd> DapStepInto <CR>",
      "Step into",
    },

    -- Step out of code
    ["<leader>du"] = {
      "<cmd> DapStepOut <CR>",
      "Step out",
    },

    -- Repl commands
    ["<leader>dr"] = {
      "<cmd> DapToggleRepl <CR>",
      "Toggle REPL",
    },
  }
}

return M
