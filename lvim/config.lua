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
table.insert(lvim.plugins, {
    "saimo/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>cp",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "dark" },
  })

vim.opt.timeoutlen = 1
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.opt.wrap = true

vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})

lvim.format_on_save.enabled = true

require("mason-lspconfig").setup({
    ensure_installed = { 
      'rust_analyzer',
      'pyright'
      },
    automatic_installation = true,
})

-- Enable DAP
local dap = require('dap')
require('dap').defaults.fallback.exception_breakpoints = ({'raised', 'uncaught'})

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
        program = function()
      -- Run a shell command to find the main.py file
      local handle = io.popen("find . -type f -name 'main.py'")
      local result = handle:read("*a")
      handle:close()

      -- Remove trailing newline character
      result = result:gsub("\n$", "")

      -- Prepend the workspace folder path
      if result ~= "" then
        return vim.fn.getcwd() .. '/' .. result
      else
        return '${workspaceFolder}/main.py'
      end
    end;
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
--    program = function()
--      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--    end;

    program = function()
      local build_output = vim.fn.system('cargo build')
      if vim.v.shell_error ~= 0 then -- Check for error in build
        print('Cargo build failed:\n', build_output)
        return nil
      end
      
      local cargo_toml_path = vim.fn.getcwd() .. '/Cargo.toml'
      local cargo_toml = vim.fn.readfile(cargo_toml_path)

      local project_name
      for _, line in ipairs(cargo_toml) do
        project_name = string.match(line, '^name%s*=%s*"(%g-)"')
        if project_name then
          break
        end
      end

      if not project_name then
        print('Could not find the project name in Cargo.toml')
        return nil
      end

      -- Assuming the executable is in the target/debug directory
      local path_to_executable = vim.fn.getcwd() .. '/target/debug/' .. project_name

      -- Check if the executable exists
      if vim.fn.filereadable(path_to_executable) == 1 then
        return path_to_executable
      else
        print('Executable not found: ' .. path_to_executable)
        return nil
      end
    end;

--    program = function()
--      -- Find the Cargo.toml file in subdirectories
--      local handle = io.popen("find . -type f -name 'Cargo.toml'")
--      local result = handle:read("*a")
--      handle:close()
--      -- Get the directory of the Cargo.toml file
--      local cargo_toml_dir = result:match("(.-)Cargo.toml")
--      if not cargo_toml_dir then
--        print('Cargo.toml not found')
--        return nil
--      end
--      -- Read the Cargo.toml file to get the project name
--      local cargo_toml = vim.fn.readfile(cargo_toml_dir .. 'Cargo.toml')
--      local project_name
--      for _, line in ipairs(cargo_toml) do
--        project_name = string.match(line, '^name%s*=%s*"(%g-)"')
--        if project_name then
--          break
--        end
--      end
--      if not project_name then
--        print('Could not find the project name in Cargo.toml')
--        return nil
--      end
--      -- Construct the path to the executable
--      local path_to_executable = cargo_toml_dir .. 'target/debug/' .. project_name
--      -- Check if the executable exists
--      if vim.fn.filereadable(path_to_executable) == 1 then
--        return path_to_executable
--      else
--        print('Executable not found: ' .. path_to_executable)
--        return nil
--      end
--    end;

    cwd = '${workspaceFolder}';
    stopOnEntry = false;
  },
}
