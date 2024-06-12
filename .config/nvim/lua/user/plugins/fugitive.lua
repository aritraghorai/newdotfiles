return {
  {
    "tpope/vim-fugitive",
    event = "User AstroGitFile",
    keys = {
      {
        "<leader>gf",
        "<cmd>Git<cr>",
        desc = "Git status",
      },
      {
        "<leader>gd",
        "<cmd>Gvdiffsplit!<cr>",
        desc = "Git diff split",
      },
      {
        "<leader>gw",
        "<cmd>Gwrite!<cr>",
        desc = "Git Write split",
      },
    },
  },
}
