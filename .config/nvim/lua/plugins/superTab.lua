---@diagnostic disable: missing-fields
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "onsails/lspkind.nvim",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local cmp = require("cmp")

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          cmp.select_next_item()
        elseif vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet.active({ direction = -1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        else
          fallback()
        end
      end, { "i", "s" }),
    })
    vim.api.nvim_set_hl(0, "PopMenu", { bg = "#1F2335", blend = 0 })
    local win_opt = {
      col_offset = 0,
      side_padding = 1,
      winhighlight = "Normal:PopMenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      max_width = 60, -- Set the maximum width of the completion window
      min_width = 30, -- Set the minimum width of the completion window
    }

    opts.window = {
      completion = cmp.config.window.bordered(win_opt),
      documentation = cmp.config.window.bordered({
        position = function(_)
          return { row = 0, col = 0 }
        end,
      }),
    }
    opts.formatting = {
      fields = { "abbr", "menu", "kind" },
      format = function(entry, item)
        -- Define menu shorthand for different completion sources.
        local menu_icon = LazyVim.config.icons.kinds
        -- Set the menu "icon" to the shorthand for each completion source.
        item.menu = menu_icon[entry.source.name]

        -- Set the fixed width of the completion menu to 60 characters.
        -- fixed_width = 20

        -- Set 'fixed_width' to false if not provided.
        fixed_width = fixed_width or false

        -- Get the completion entry text shown in the completion window.
        local content = item.abbr

        -- Set the fixed completion window width.
        if fixed_width then
          vim.o.pumwidth = fixed_width
        end

        -- Get the width of the current window.
        local win_width = vim.api.nvim_win_get_width(0)

        -- Set the max content width based on either: 'fixed_width'
        -- or a percentage of the window width, in this case 20%.
        -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
        local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)
        local icons = LazyVim.config.icons.kinds
        if icons[item.kind] then
          item.kind = icons[item.kind] .. item.kind
        end

        -- Truncate the completion entry text if it's longer than the
        -- max content width. We subtract 3 from the max content width
        -- to account for the "..." that will be appended to it.
        if #content > max_content_width then
          item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
        else
          item.abbr = content .. (" "):rep(max_content_width - #content)
        end
        return item
      end,
    }

    -- opts.window = {
    --   completion = cmp.config.window.bordered({
    --     border = "double",
    --     winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenu,CursorLine:PmenuSel,Search:None",
    --   }),
    --   documentation = cmp.config.window.bordered(),
    -- }
    return opts
  end,
}
