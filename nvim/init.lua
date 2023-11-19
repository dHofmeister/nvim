-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.open()
end

dap.defaults.fallback.exception_breakpoints = ({ "raised", "uncaught" })

require("neotest").setup({
  adapters = {
    require("neotest-rust")
  }
})
