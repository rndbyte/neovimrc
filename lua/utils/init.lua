local M = {}

function M.get_dap_args()
    return coroutine.create(function (dap_run_co)
        local args = {}
        vim.ui.input({ prompt = "Args: " }, function (input)
            args = require("dap.utils").splitstr(input or "")
            coroutine.resume(dap_run_co, args)
        end)
    end)
end

function M.get_user_input(input_name, default_value)
    local message = string.format('%s (default %s):', input_name, default_value)
    local name = vim.fn.input(message) or ''
    name = name == '' and default_value or name
    return name
end

local neotest_configuration_mem = {}
setmetatable(neotest_configuration_mem, {__mode = "kv"})

---@param adapter string
function M.select_neotest_configuration(adapter)
    local options = {
        { name = 'Test local', configuration = "local" },
        { name = 'Test in container', configuration = "container" }
    }

    if not neotest_configuration_mem[adapter] then
        return coroutine.create(function ()
            vim.ui.select(options, {
                prompt = 'Configuration: ',
                format_item = function(i) return i.name end,
            }, function (option)
                if option then
                    neotest_configuration_mem[adapter] = option.configuration
                    coroutine.yield(option.configuration)
                else
                    vim.notify('No configuration selected', vim.log.levels.INFO, { title = 'NEOTEST' })
                end
            end)
        end)
    else
        return coroutine.create(function ()
            local cnf = neotest_configuration_mem[adapter]
            neotest_configuration_mem[adapter] = nil

            coroutine.yield(cnf)
        end)
    end
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
    local out = {}
    local seen = {}

    for _, value in ipairs(list) do
        if not seen[value] then
            table.insert(out, value)
            seen[value] = true
        end
    end

    return out
end

return M
