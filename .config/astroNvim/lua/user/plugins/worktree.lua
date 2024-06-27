return {
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      vim.cmd [[
         nnoremap <leader>gw :lua require('git-worktree').create_worktree()<CR>
         nnoremap <leader>gW :lua require('git-worktree').switch_worktree()<CR>
         nnoremap <leader>gD :lua require('git-worktree').delete_worktree()<CR>
       ]]
    end,
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>gWc",
        function() require("git-worktree").create_worktree() end,
        desc = "Added Create New Worktree",
      },
      {
        "<leader>gWs",
        function() require("git-worktree").switch_worktree() end,
        desc = "Switch WorkTree",
      },
      {
        "<leader>gWd",
        function() require("git-worktree").delete_worktree() end,
        desc = "Delete wrkTree",
      },
      {
        "<leader>gWf",
        function() require("telescope").load_extension "git_worktree" end,
        desc = "WorkTree",
      },
    },
  },
}
