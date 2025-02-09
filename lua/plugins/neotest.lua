return {
    {
        "nvim-neotest/neotest",
        lazy = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            adapters = {},
            diagnostic = { enabled = true },
            status = { virtual_text = true, signs = true },
            output = { open_on_run = true },
        },
        config = function (_, opts)
            local neotest = require("neotest")
            local neotest_ns = vim.api.nvim_create_namespace("neotest") -- api call creates or returns namespace

            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        local message =
                            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                        return message
                    end,
                },
            }, neotest_ns)

            if opts.adapters then
                ---@type neotest.Adapter[]
                local adapters = {}

                for name, config in pairs(opts.adapters or {}) do
                    if type(name) == "number" then
                        if type(config) == "string" then
                            config = require(config) --[[@as neotest.Adapter]]
                        end

                        adapters[#adapters+1] = config
                    elseif config ~= false then
                        ---@type table
                        local adapter = require(name)

                        if type(config) == "table" and not vim.tbl_isempty(config) then
                            local meta = getmetatable(adapter)

                            if adapter.setup then
                                adapter.setup(config)
                            elseif meta and meta.__call then
                                adapter = adapter(config)
                            else
                                error("Adapter " .. name .. " does not support setup")
                            end
                        end

                        adapters[#adapters+1] = adapter
                    end
                end

                opts.adapters = adapters
            end

            neotest.setup(opts)

            vim.keymap.set("n", "<leader>ts", function ()
                neotest.summary.toggle()
            end)

            vim.keymap.set("n", "<leader>to", function ()
                neotest.output.open({ enter = true, auto_close = true })
            end)

            vim.keymap.set("n", "<leader>tO", function ()
                neotest.output_panel.toggle()
            end)

            -- Run the test nearest to the cursor
            vim.keymap.set("n", "<leader>tt", function()
                neotest.run.run()
            end)

            -- Run all tests in the file
            vim.keymap.set("n", "<leader>tf", function()
                neotest.run.run({
                    vim.fn.expand("%"),
                    suite = false,
                    extra_args = { "-coverprofile=".. vim.fn.getcwd() .. "/cover.out" },
                })
            end)

            -- Run all tests in the package
            vim.keymap.set("n", "<leader>tp", function()
                neotest.run.run({
                    vim.fn.expand("%:p:h"),
                    suite = true,
                    extra_args = { "-coverprofile=".. vim.fn.getcwd() .. "/cover.out" },
                })
            end)
        end
    }
}
