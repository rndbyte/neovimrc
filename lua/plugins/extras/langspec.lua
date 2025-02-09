-- https://github.com/neovim/nvim-lspconfig/blob/1aa9f36b6d542dafc0b4a38c48969d036003b00a/doc/lspconfig.txt#L50
---@class _.lspconfig.options: vim.lsp.ClientConfig
---@field root_dir fun(filename, bufnr): string|nil
---@field name string?
---@field filetypes string[]|nil
---@field autostart boolean? Default true
---@field single_file_support boolean? Default nil
---@field silent boolean? Default false
---@field on_new_config fun(new_config, new_root_dir)?

---@class LangConfig
---@field ft string|string[]?
---@field parsers string[]?
---@field lsp LangConfig.lsp?
---@field dap LangConfig.dap?
---@field test LangConfig.test?

---@class LangConfig.lsp
---@field cmdtools string[]
---@field servers table<string, _.lspconfig.options>

---@class LangConfig.dap
---@field cmdtools string[]
---@field adapters table<string, fun(config)>

---@alias LangConfig.test LangTestAdapter[]|LangTestAdapter

---@class LangTestAdapter
---@field [1] string? package name
---@field branch string
---@field adapters table

---@class LangSpec
---@field defaults LangConfig
---@field plugin_specs LazyPluginSpec[]
---@field append fun(self: LangSpec, ...: LazyPluginSpec): LangSpec
---@field prepend fun(self: LangSpec, ...: LazyPluginSpec): LangSpec
---@field generate fun(self: LangSpec, ...: LangConfig): LazyPluginSpec[]

---@type LangConfig
local defaults = {
    ft = "",
    parsers = {},
    lsp = {
        cmdtools = {},
        servers = {},
    },
    dap = {
        cmdtools = {},
        adapters = {},
    },
    test = {},
}

---@class LangSpec
local M = {
    defaults = defaults,
    plugin_specs = {},
}

---@param o table
---@return LangSpec
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.defaults = defaults
    self.plugin_specs = {}

    return o
end

---@param ... LazyPluginSpec
function M:append(...)
    vim.list_extend(self.plugin_specs, { ... })

    return M
end

---@param ... LazyPluginSpec
function M:prepend(...)
    local specs = { ... }

    vim.list_extend(specs, self.plugin_specs)
    self.plugin_specs = specs

    return M
end

---@param conf LangConfig
---@return LazyPlugin[]
function M:generate(conf)
    ---@type LangConfig
    conf = vim.tbl_deep_extend("force", M.defaults, conf or {})

    local specs = self.plugin_specs

    -- setup PARSERS
    if not vim.tbl_isempty(conf.parsers) then
        table.insert(specs, {
            "nvim-treesitter/nvim-treesitter",
            opts = function (_, opts)
                vim.list_extend(opts.ensure_installed, conf.parsers)
            end
        })
    end

    -- setup LSP
    if not vim.tbl_isempty(conf.lsp.cmdtools) then
        table.insert(specs, {
            "williamboman/mason-lspconfig.nvim",
            opts = function (_, opts)
                vim.list_extend(opts.ensure_installed, conf.lsp.cmdtools)

                if not vim.tbl_isempty(conf.lsp.servers) then
                    local lsp_handlers = {}

                    for _, server in ipairs(conf.lsp.servers) do
                        lsp_handlers[server.name] = function (_)
                            require("lspconfig")[server.name].setup(server)
                        end
                    end

                    vim.list_extend(opts.handlers, lsp_handlers)
                end
            end
        })
    end

    -- setup DAP
    if not vim.tbl_isempty(conf.dap) then
        table.insert(specs, {
            "jay-babu/mason-nvim-dap.nvim",
            ft = conf.ft,
            opts = function (_, opts)
                vim.list_extend(opts.ensure_installed, conf.dap.cmdtools)

                if not vim.tbl_isempty(conf.dap.adapters) then
                    opts.handlers = vim.tbl_deep_extend("force", {}, opts.handlers, conf.dap.adapters)
                end
            end
        })
    end

    -- setup TESTS
    if not vim.tbl_isempty(conf.test) then
        local _, first = next(conf.test)

        if type(first) == "string" then
            conf.test = { conf.test }
        end

        for _, item in ipairs(conf.test) do
            if not (item[1] == nil or item[1] == "") and item.adapters then
                local spec = {
                    "nvim-neotest/neotest",
                    optional = true,
                    ft = conf.ft,
                    dependencies = {
                        item[1],
                        branch = item.branch or nil,
                    },
                    opts = {
                        adapters = item.adapters,
                    },
                }

                table.insert(specs, spec)
            end
        end
    end

    self.plugin_specs = specs

    return specs
end

return M
