-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "BufRead",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup()
      require("copilot_cmp").setup()
    end, 100)
  end
})

table.insert(lvim.plugins, {"mfussenegger/nvim-dap"})
table.insert(lvim.plugins, {"mfussenegger/nvim-dap-python"})

vim.opt.timeoutlen = 1

-- Enable DAP
lvim.builtin.dap.active = true
local dap = require('dap')

-- Python DAP configuration
dap.adapters.python = {
  type = 'executable';
  command = 'python3';
  args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";
    program = "${file}";
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python3'
      end
    end;
  },
}

-- Rust DAP configuration
dap.adapters.rust = {
  type = 'executable';
  command = 'lldb-vscode';
  name = "lldb";
}

dap.configurations.rust = {
  {
    type = 'rust';
    request = 'launch';
    name = "Launch file";
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end;
    cwd = '${workspaceFolder}';
    stopOnEntry = false;
  },
}

