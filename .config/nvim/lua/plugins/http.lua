return {
  {
    "mistweaverco/kulala.nvim",
    config = function()
      require("kulala").setup()
    end,
    keys = {
      {
        "<leader>r",
        function()
          require("kulala").run()
        end,
        desc = "Run Current Request",
      },
    },
  },
}
