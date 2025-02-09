return {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
		vim.keymap.set("n", "<leader>gb", function ()
    		vim.cmd.Git('blame')
		end)

		local user_fugitive = vim.api.nvim_create_augroup("user_fugitive", {})

		local autocmd = vim.api.nvim_create_autocmd
		autocmd("BufWinEnter", {
			group = user_fugitive,
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
                    return
                end

				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }

                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, opts)

                -- rebase always
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git('pull --rebase')
                end, opts)
			end
		})

		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
	end
}
