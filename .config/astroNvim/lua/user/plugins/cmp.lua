return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "jcdickinson/codeium.nvim", -- add cmp source as dependency of cmp cmp
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-emoji", -- add cmp source as dependency of cmp
    "zbirenbaum/copilot-cmp",
    opts = {},
  },
  opts = function(_, opts)
    require("copilot_cmp").setup()
    require("codeium").setup {}
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    return require("astronvim.utils").extend_tbl(opts, {
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
        { name = "codeium", priority = 900 }, -- add new source
        { name = "emoji", priority = 10004 },
        { name = "copilot", priority = 905 },
      },
      mapping = {
        -- so that tabout plugin can work
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },
      formatting = {
        fields = { "abbr", "menu", "kind" },
        format = require("lspkind").cmp_format {
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          preset = "codicons",
          symbol_map = {
            Codeium = "󰏗",
            Array = "󰅪",
            Boolean = "⊨",
            Class = "󰌗",
            Constructor = "",
            Key = "󰌆",
            Namespace = "󰅪",
            Null = "NULL",
            Number = "#",
            Object = "󰀚",
            Package = "󰏗",
            Property = "",
            Reference = "",
            Snippet = "",
            String = "󰀬",
            TypeParameter = "󰊄",
            Unit = "",
          },
        },
      },
    })
  end,
}
