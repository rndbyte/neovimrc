local dap = require('dap')
local utils = require("utils")
local lspconfig = require("lspconfig")
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)
local generator = require("plugins.extras.langspec"):new({})

---@type LangConfig
local conf = {
    ft = "go",
    parsers = {
        "go",
        "gomod",
        "gosum",
        "gowork",
    },
    lsp = {
        cmdtools = {
	    	"gopls",
            "golangci_lint_ls",
        },
        servers = {
            gopls = {
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                cmd = { "gopls" },
                cmd_env = {
                    GOFLAGS = "-tags=unit,integration",
                },
                -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = {
                            unusedparams = true,
                            composites = false,
                        },
                        gofumpt = true,
                    },
                },

            },
        },
    },
    dap = {
        cmdtools = {
            "delve",
        },
        adapters = {
            delve = function (config)
                require('dap-go').setup()
                -- At this point 'nvim-dap-go' already created configurations for 'go' adapter.
                -- But we want to use 'delve' adapter's name to provide compatibility with 'mason-nvim-dap'.
                config.adapters = dap.adapters.go
                config.configurations = dap.configurations.go

                for _, val in ipairs(config.configurations) do
                    val.type = "delve"
                end

                -- This is a hack to rewrite local config from dap-go.debug_test()
                dap.listeners.on_config['dap-go'] = function(conf)
                    local copy_conf = vim.deepcopy(conf)
                    if copy_conf.type == "go" and copy_conf.mode == "test" and copy_conf.request == "launch" then
                         copy_conf.type = "delve"
                    end

                    return copy_conf
                end

                dap.adapters.go = nil
                dap.configurations.go = nil

                require('mason-nvim-dap').default_setup(config)
            end
        },
    },
    test = {
        "fredrikaverpil/neotest-golang",
        branch = "docker",
        adapters = {
            ["neotest-golang"] = {
                cmd_prefix = function ()
                    local co = utils.select_neotest_configuration("gotest")
                    local _, configuration = coroutine.resume(co)

                    if configuration == "container" then
                        local container = utils.get_user_input("Enter container name", "docker")

                        return { vim.env.HOME .. "/.config/nvim/scripts/dgotest.sh", container }
                    else
                        return {}
                    end
                end,
                go_test_args = {
                    "-v",
                    "-race",
                    "-tags=unit,integration",
                    "-timeout=30s",
                    "-count=1",
                    "-coverprofile=".. vim.fn.getcwd() .. "/cover.out",
                },
            },
        },
    },
}

return generator:generate(conf)
