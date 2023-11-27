if true then
  return {
    {
      "catppuccin/nvim",
      lazy = false,
      name = "catppuccin",
      config = function()
        require("catppuccin").setup({ flavour = "macchiato" })
      end,
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin",
      },
    },
  }
end
