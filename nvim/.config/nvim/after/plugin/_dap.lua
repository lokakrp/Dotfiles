local dap = require('dap')
local dapui = require('dapui')

-- Setup dap-python
require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

-- Key mappings
vim.keymap.set('n', '<Leader>dt', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dc', function() dap.continue() end)

-- GDB adapter configuration
dap.adapters.gdb = {
  type = 'executable',
  command = 'gdb',
  args = { '--interpreter=mi2', '--eval-command', 'set print pretty on' }
}

-- DAP configurations for C
dap.configurations.c = {
  {
    name = 'Launch',
    type = 'gdb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
  },
  {
    name = 'Select and attach to process',
    type = 'gdb',
    request = 'attach',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require('dap.utils').pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  },
}

-- Ensure dapui is set up
dapui.setup()

-- DAP UI listeners
dap.listeners.after.event_initialized['dapui_config'] = function()
  if dapui and dapui.open then
    dapui.open()
  end
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  if dapui and dapui.close then
    dapui.close()
  end
end
dap.listeners.before.event_exited['dapui_config'] = function()
  if dapui and dapui.close then
    dapui.close()
  end
end

