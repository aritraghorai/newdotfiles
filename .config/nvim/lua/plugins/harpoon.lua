return {
  {
    "ThePrimeagen/harpoon",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>a",
        function() require("harpoon.mark").add_file() end,
        desc = "Added Word To Harpon",
      },
      {
        "<C-e>",
        function() require("harpoon.ui").toggle_quick_menu() end,
        desc = "Toogle Harpoon Menu",
      },
      {
        "<leader>1",
        function() require("harpoon.ui").nav_file(1) end,
        desc = "Go to Harpoon 1",
      },
      {
        "<leader>2",
        function() require("harpoon.ui").nav_file(2) end,
        desc = "Go to Harpoon 2",
      },
      {
        "<leader>3",
        function() require("harpoon.ui").nav_file(3) end,
        desc = "Go to Harpoon 3",
      },
      {
        "<leader>4",
        function() require("harpoon.ui").nav_file(4) end,
        desc = "Go to Harpoon 4",
      },
    },
  },
}
