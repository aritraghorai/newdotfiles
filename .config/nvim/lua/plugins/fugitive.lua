return {
  {
    "tpope/vim-fugitive",
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
      {
        "<leader>gl",
        "<cmd>Git log<cr>",
        desc = "Git log",
      },
      {
        "<leader>gp",
        "<cmd>Git push<cr>",
        desc = "Git push",
      },
    },
  },
}
