require("config.set")
require("config.remap")
require("config.lazy_init")

-- Optional custom config
local has_custom, _ = pcall(require, "config.custom")

if has_custom then
    vim.notify("[custom] module was loaded")
end

local augroup = vim.api.nvim_create_augroup
local user_group = augroup('CustomUserGroup', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = user_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = user_group,
    callback = function(e)
        local opts = { buffer = e.buf }

	    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
	    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "<leader>vji", function() vim.lsp.buf.implementation() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
