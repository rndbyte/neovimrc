local generator = require("plugins.extras.langspec"):new({})
local utils = require("utils")

---@type LangConfig
local conf = {
    ft = "php",
    parsers = {
        "php",
    },
}

if vim.fn.executable("php") == 1 then
    local extended = {
        lsp = {
            cmdtools = {
                "phpactor",
            },
            servers = {},
        },
        dap = {
            cmdtools = {
                "php", -- php-debug-adapter
            },
            adapters = {
                php = function (config)
                    local command = {
                        type = 'executable',
                        command = vim.env.HOME .. "/.local/share/nvim/mason/bin/php-debug-adapter",
                    }

                    local configurations = {
                        {
                            type = 'php',
                            request = 'launch',
                            name = 'XDebug Local',
                            port = 9000,
                            program = "${file}",
                        },
                        {
                            type = 'php',
                            request = 'launch',
                            name = 'XDebug Remote',
                            port = 9000,
                            pathMappings = function()
                                local default = '/var/www/html'
                                local message = string.format('Path (default %s):', default)
                                local path = vim.fn.input(message) or ''
                                path = path == '' and default or path
                                return { [path] = '${workspaceFolder}' }
                            end
                        },
                        {
                            type = "php",
                            request = "launch",
                            name = "XDebug with arguments",
                            port = 9000,
                            program = "tests/Domain/Builder/Trading/Change/${fileBasename}",
                            -- cwd = "${workspaceFolder}",
                            stopOnEntry = false,
                            -- args = utils.get_dap_args,
                            runtimeArgs = {
                                --"-dxdebug.start_with_request=yes",
                                "exec -it new_management_service_dev_1",
                            },
                            args = {
                                "sh -c \"php\"",
                            },
                            runtimeExecutable = "docker",
                            env = {
                                XDEBUG_MODE = "develop,coverage,debug",
                                XDEBUG_CONFIG = "idekey=PHP_STORM",
                            },
                            pathMappings = function()
                                local default = '/var/www/html'
                                local message = string.format('Path (default %s):', default)
                                local path = vim.fn.input(message) or ''
                                path = path == '' and default or path
                                return { [path] = '${workspaceFolder}' }
                            end,
                            externalConsole = true,
                        }
                    }

                    config.adapters = command
                    config.configurations = configurations

                    require('mason-nvim-dap').default_setup(config)
                end
            },
        },
        test = {
            "olimorris/neotest-phpunit",
            adapters = {
                ["neotest-phpunit"] = {
                    filter_dirs = { ".git", "node_modules", "vendor" },
                    root_files = { "composer.json", "phpunit.xml", "phpunit.xml.dist", ".gitignore" },
                    env = function ()
                        local env = {
                            REMOTE_PHPUNIT_BIN = "vendor/bin/phpunit",
                            IDE_KEY = "nvim",
                        }

                        local co = utils.select_neotest_configuration("phpunit")
                        local _, configuration = coroutine.resume(co)

                        if configuration == "container" then
                            local container = utils.get_user_input("Enter container name", "docker")
                            env.CONTAINER = container
                        end

                        return env
                    end,
                    phpunit_cmd = function()
                        local co = utils.select_neotest_configuration("phpunit")
                        local _, configuration = coroutine.resume(co)

                        if configuration == "container" then
                            return vim.env.HOME .. "/.config/nvim/scripts/dphpunit.sh"
                        else
                            return "vendor/bin/phpunit"
                        end
                    end,
                    --dap = {
                    --    type = "php",
                    --    request = "launch",
                    --    name = "Launch file (Xdebug)",
                    --    program = "${file}",
                    --    cwd = "${workspaceFolder}",
                    --    port = 9000,
                    --    stopOnEntry = false,
                    --},
                },
            },
        },
    } --[[@as LangConfig]]

    conf = vim.tbl_extend("force", conf, extended)
end

return generator:generate(conf)
