return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "lemminx" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        html = {},
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "sass",
            "less",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
          },
          init_options = {
            html = {
              options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ["bem.enabled"] = true,
              },
            },
          },
        },
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
