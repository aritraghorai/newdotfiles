return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "bash" } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "bash-language-server", "shellcheck", "shfmt" } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
      formatters = {
        shfmt = {
          prepend_args = function(_, ctx)
            local args = {}
            local bo = vim.bo[ctx.buf]
            if bo.expandtab then
              local tab_size = bo.tabstop or 2
              local indent_size = bo.shiftwidth
              if indent_size == 0 or not indent_size then
                indent_size = tab_size
              end
              vim.list_extend(args, { "-i", tostring(indent_size) })
            end
            return args
          end,
        },
      },
    },
  },
}
