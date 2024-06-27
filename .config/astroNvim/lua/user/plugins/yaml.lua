return {
  {
    ft = { "yaml" },
    "williamboman/mason-lspconfig.nvim",
    opts = function()
      require("lspconfig").yamlls.setup {
        settings = {
          yaml = {
            schemas = {
              ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
              ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
              ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
              ["https://gist.githubusercontent.com/aritraghorai/3c2c706df071b8979b078b9ced076a8f/raw/9166e8984289fda0c792ea6c0871c8b92c46638b/boot.json"] = "application.yaml",
            },
          },
        },
      }
    end,
  },
}
