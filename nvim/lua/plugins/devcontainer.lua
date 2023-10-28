return {
  "https://codeberg.org/esensar/nvim-dev-container",
  dependencies = "nvim-treesitter/nvim-treesitter",
  setup = function()
    require("devcontainer").setup({
      generate_commands = true,
    })
  end,
}
