return {
  {
    "CRAG666/code_runner.nvim",
    opts = function()
      require("code_runner").setup {
        filetype = {
          java = {
            -- "cd $dir &&",
            -- "java $fileName",
            "java $dir/$fileName",
          },
        },
      }
    end,
    keys = {
      { "<leader>R", "<cmd>RunFile<cr>", desc = "Compiler:RunFile" },
    },
    cmd = {
      "RunFile",
    },
  },
}
