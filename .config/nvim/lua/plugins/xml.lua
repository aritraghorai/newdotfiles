return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "lemminx" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lemminx = {
          -- Optional initialization options for XML and XSLT
          init_options = {
            settings = {
              xml = {
                format = {
                  enabled = true,
                  splitAttributes = "preserve",
                  maxLineWidth = 280,
                },
              },
              xslt = {
                format = {
                  enabled = true,
                  splitAttributes = "preserve",
                  maxLineWidth = 280,
                },
              },
            },
          },
        },
      },
    },
  },
}
