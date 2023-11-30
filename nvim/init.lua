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

dap.defaults.fallback.exception_breakpoints = { "raised", "uncaught" }

dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode",
  name = "lldb",
}

require("neotest").setup({
  adapters = {
    require("neotest-rust")({
      args = { "--no-capture" },
      dap_adapter = "lldb",
    }),
  },
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })

local wk = require("which-key")
wk.register({
  C = {
    name = "ChatGPT",
    c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
    e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
    g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
    t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
    k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
    d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
    a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
    o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
    s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
    f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
    x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
    r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
    l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
  },
}, { prefix = "<leader>" })

require("chatgpt").setup({
  openai_params = {
    model = "gpt-4-1106-preview",
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 800,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  openai_edit_params = {
    model = "gpt-4-1106-preview",
    temperature = 0,
    top_p = 1,
    n = 1,
  },
})

require("notify").setup({
  background_colour = "#1e2030",
})
