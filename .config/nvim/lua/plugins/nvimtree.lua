-- init.lua (early)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.opt.termguicolors = true
--
-- -- using lazy.nvim
-- -- lua/plugins/nvim-tree.lua
-- return {
--   "nvim-tree/nvim-tree.lua",
--   dependencies = {
--     "nvim-tree/nvim-web-devicons", -- pretty icons
--   },
--
--   config = function()
--     -- optional: custom on_attach for keymaps
--     local function my_on_attach(bufnr)
--       local api = require("nvim-tree.api")
--       local view = require("nvim-tree.actions")
--       local function opts(desc)
--         return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
--       end
--       api.config.mappings.default_on_attach(bufnr)
--       vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvim-tree" })
--       vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
--     end
--
--     -- devicons with defaults and color icons
--     require("nvim-web-devicons").setup({
--       color_icons = true,
--       default = true,
--       strict = true,
--     })
--
--     require("nvim-tree").setup({
--       on_attach = my_on_attach,
--
--       sort = { sorter = "case_sensitive" },
--
--       view = {
--         width = 34,
--         side = "left",
--         preserve_window_proportions = true,
--         float = {
--           enable = false, -- set true for a floating, rounded panel
--           quit_on_focus_loss = true,
--           open_win_config = {
--             relative = "editor",
--             border = "rounded",
--             width = 0.9,
--             height = 0.9,
--             row = 1,
--             col = 1,
--           },
--         },
--       },
--
--       renderer = {
--         highlight_git = true,
--         highlight_diagnostics = true,
--         root_folder_label = ":~:s?$HOME??",
--         add_trailing = false,
--         full_name = false,
--         group_empty = true,
--         indent_width = 2,
--         indent_markers = {
--           enable = true,
--           inline_arrows = false,
--           icons = {
--             corner = "└",
--             edge = "│",
--             item = "│",
--             none = " ",
--           },
--         },
--         icons = {
--           webdev_colors = true,
--           git_placement = "after",
--           glyphs = {
--             default = "",
--             symlink = "",
--             folder = {
--               arrow_closed = "",
--               arrow_open = "",
--               default = "",
--               open = "",
--               empty = "",
--               empty_open = "",
--               symlink = "",
--               symlink_open = "",
--             },
--             git = {
--               unstaged = "",
--               staged = "",
--               unmerged = "",
--               renamed = "",
--               untracked = "",
--               deleted = "",
--               ignored = "",
--             },
--           },
--         },
--         special_files = { "README.md", "Makefile", "package.json" },
--       },
--
--       diagnostics = {
--         enable = true,
--         show_on_dirs = true,
--         show_on_open_dirs = true,
--         debounce_delay = 50,
--         icons = {
--           hint = "",
--           info = "",
--           warning = "",
--           error = "",
--         },
--       },
--
--       git = {
--         enable = true,
--         ignore = false,
--         timeout = 200,
--       },
--
--       filters = {
--         dotfiles = false,
--         git_ignored = false,
--         custom = { "^.git$", "node_modules", ".cache" },
--       },
--
--       actions = {
--         open_file = {
--           quit_on_open = false,
--           resize_window = true,
--           window_picker = {
--             enable = true,
--             chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
--             picker = "default",
--           },
--         },
--         file_popup = {
--           open_win_config = {
--             border = "rounded",
--           },
--         },
--       },
--
--       hijack_netrw = true,
--       disable_netrw = true,
--       respect_buf_cwd = true,
--       sync_root_with_cwd = true,
--       update_focused_file = {
--         enable = true,
--         update_root = true,
--         ignore_list = {},
--       },
--     })
--
--     -- Optional: polish highlights for a cohesive look
--     -- Tip: :NvimTreeHiTest to see groups in use
--     vim.cmd([[
--       hi NvimTreeIndentMarker guifg=#3b4261
--       hi NvimTreeFolderIcon   guifg=#89b4fa
--       hi NvimTreeOpenedFile   gui=bold
--       hi NvimTreeGitDirty     guifg=#f9e2af
--       hi NvimTreeGitNew       guifg=#a6e3a1
--       hi NvimTreeGitDeleted   guifg=#f38ba8
--       hi NvimTreeSpecialFile  guifg=#cba6f7 gui=underline
--       hi link NvimTreeImageFile Title
--     ]])
--   end,
-- }
-- using lazy.nvim
return {
  "nvim-tree/nvim-tree.lua",
  event = "VeryLazy", -- load after startup UI is ready
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle nvim-tree" },
    { "<C-n>", "<cmd>NvimTreeFocus<CR>", desc = "Focus nvim-tree" },
    {
      "<Esc>",
      function()
        if vim.bo.filetype == "NvimTree" then
          require("nvim-tree.api").tree.close()
        else
          -- fall back to normal Esc
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end
      end,
      mode = "n",
      desc = "Close nvim-tree if focused",
    },
  },
  opts = function()
    -- optional: strict icons and color
    require("nvim-web-devicons").setup({
      color_icons = true,
      default = true,
      strict = true,
      override_by_extension = {
        ["md"] = { icon = "󰍔", color = "#89b4fa", name = "Markdown" },
        ["ts"] = { icon = "", color = "#74c7ec", name = "TypeScript" },
        ["tsx"] = { icon = "", color = "#74c7ec", name = "TSX" },
        ["json"] = { icon = "", color = "#f9e2af", name = "Json" },
        ["toml"] = { icon = "", color = "#f2cdcd", name = "Toml" },
      },
    })
    -- Auto close if it's the last window in the tab
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "NvimTree_*",
      callback = function()
        local api = require("nvim-tree.api")
        if #vim.api.nvim_tabpage_list_wins(0) == 1 then
          api.tree.close()
        end
      end,
    })

    -- Optional: open tree when launching nvim on a directory
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = function(data)
        local directory = vim.fn.isdirectory(data.file) == 1
        if directory then
          require("nvim-tree.api").tree.open()
        end
      end,
    })

    return {
      -- smooth, floating, rounded panel
      view = {
        side = "left",
        width = 34,
        float = {
          enable = true,
          quit_on_focus_loss = true,
          open_win_config = function()
            local columns = vim.o.columns
            local lines = vim.o.lines
            local win_w = math.floor(columns * 0.28)
            local win_h = math.floor(lines * 0.85)
            return {
              relative = "editor",
              border = "rounded",
              width = win_w,
              height = win_h,
              row = math.floor((lines - win_h) / 2),
              col = 2,
            }
          end,
        },
      },

      -- elegant rendering
      renderer = {
        highlight_git = true,
        highlight_diagnostics = true,
        root_folder_label = function(path)
          return "󰉋  " .. vim.fn.fnamemodify(path, ":t")
        end,
        group_empty = true,
        add_trailing = false,
        full_name = false,
        indent_width = 2,
        indent_markers = {
          enable = true,
          inline_arrows = false,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            none = " ",
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = "after",
          padding = " ",
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "",
            modified = "●",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "",
              staged = "",
              unmerged = "",
              renamed = "",
              untracked = "",
              deleted = "",
              ignored = "",
            },
          },
        },
        special_files = { "README.md", "Makefile", "package.json" },
      },

      -- compact, tidy list
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = { "^.git$", "node_modules", ".cache", "__pycache__" },
      },

      -- tasteful status badges
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 50,
        icons = {
          hint = "󰌶",
          info = "",
          warning = "",
          error = "",
        },
      },

      git = {
        enable = true,
        ignore = false,
        timeout = 200,
      },

      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
            chars = "ASDFGHJKLQWERTYUIOPZXCVBNM",
          },
        },
        file_popup = {
          open_win_config = { border = "rounded" },
        },
      },

      -- sync with cwd and focus behavior
      respect_buf_cwd = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      disable_netrw = true,
      hijack_netrw = true,
      sort = { sorter = "case_sensitive" },
    }
  end,
}
