return {
  {
    "MeanderingProgrammer/markdown.nvim",
    ft = "markdown",
    name = "render-markdown",
    config = function()
      require("render-markdown").setup({})
    end,
  },
}
