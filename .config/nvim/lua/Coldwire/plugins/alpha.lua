return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    enabled = true,
    init = false,
    opts = function()
        local dashboard = require("alpha.themes.dashboard")
        -- Define and set highlight groups for each logo line
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = "#344e41" }) -- Indigo
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = "#3a5a40" }) -- Deep Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = "#588157" }) -- Deep Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = "#588157" }) -- Medium Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo5", { fg = "#a3b18a" }) -- Light Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo6", { fg = "#dad7cd" }) -- Very Light Purple
        vim.api.nvim_set_hl(0, "NeovimDashboardUsername", { fg = "#dad7cd" }) -- light purple
        dashboard.section.header.type = "group"
        dashboard.section.header.val = {
            {
                type = "text",
                val = "   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                opts = { hl = "NeovimDashboardLogo1", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                opts = { hl = "NeovimDashboardLogo2", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                opts = { hl = "NeovimDashboardLogo3", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                opts = { hl = "NeovimDashboardLogo4", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                opts = { hl = "NeovimDashboardLogo5", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                opts = { hl = "NeovimDashboardLogo6", shrink_margin = false, position = "center" },
            },
            {
                type = "padding",
                val = 1,
            },
            {
                type = "text",
                val = "𝙾𝚑 𝚝𝚑𝚎 𝚓𝚘𝚢 𝚘𝚏 𝚑𝚊𝚟𝚒𝚗𝚐 𝚢𝚘𝚞𝚛 𝚘𝚠𝚗 𝚌𝚞𝚜𝚝𝚘𝚖 𝚝𝚎𝚡𝚝 𝚎𝚍𝚒𝚝𝚘𝚛",
                opts = { hl = "NeovimDashboardUsername", shrink_margin = false, position = "center" },
            },
        }
    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
      dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
      dashboard.button("r", " " .. " Recent files",    "<cmd> Telescope oldfiles <cr>"),
      dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
      dashboard.button("Z", " " .. " Open Directories", "<cmd><leader>ee<cr>"),
      dashboard.button("c", " " .. " Config",          "<cmd> <cr>"),
      dashboard.button("s", " " .. " Restore Session", "<cmd><leader>wr<cr>"),
    --dashboard.button("x", " " .. " Lazy Extras",     "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#a3b18a" }) -- Dark Indigo
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#dad7cd" }) -- Light Purple
        vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#8BC34A" }) -- Greenish
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#edd691" })

        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
        end
        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"
        dashboard.opts.layout[1].val = 3
        return dashboard
    end,
    config = function(_, dashboard)
        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                once = true,
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            once = true,
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = "⚡ Neovim loaded "
                    .. stats.loaded
                    .. "/"
                    .. stats.count
                    .. " plugins in "
                    .. ms
                    .. "ms"
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}
