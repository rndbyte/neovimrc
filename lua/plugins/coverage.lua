return {
    {
        "andythigpen/nvim-coverage",
        event = "VeryLazy",
        dependencies = {
            "asb/lua-xmlreader",
            lazy = true,
        },
        opts = {
            auto_reload = true,
            commands = false,
            highlights = {
                covered = { cp = "#C3E88D" },
                uncovered = { cp = "#F07178" },
            },
            signs = {
                covered = { hl = "CoverageCovered", text = "▎" },
                uncovered = { hl = "CoverageUncovered", text = "▎" },
            },
            summary = {
                min_coverage = 85.0,
            },
            lang = {
                go = {
                    coverage_file = "cover.out",
                },
                php = {
                    coverage_file = "cover.xml",
                    path_mappings = {
                        ["/var/www/html"] = ""
                    },
                },
            },
        },
        config = function(_, opts)
            local coverage = require("coverage")
            local enabled = require("coverage.signs").is_enabled()

            coverage.setup(opts)

            -- Toggle coverage
            vim.keymap.set("n", "<leader>ct", function()
                if enabled then
                    coverage.clear()
                else
                    coverage.load(true)
                end
            end)

            -- Coverage summary
            vim.keymap.set("n", "<leader>cs", function()
                if not enabled then
                    coverage.load(true)
                    coverage.hide()
                end

                coverage.summary()

                if not enabled then
                    coverage.clear()
                end
            end)
        end
    }
}
