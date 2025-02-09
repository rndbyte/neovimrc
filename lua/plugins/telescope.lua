return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	config = function()
		require('telescope').setup({})

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
		vim.keymap.set('n', '<C-p>', builtin.git_files, {})
		vim.keymap.set('n', '<leader>pws', function()
			local word = vim.fn.expand("<cword>")
    		builtin.grep_string({ search = word })
		end)

		vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)

        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

		-- Harpoon integration
		local harpoon = require('harpoon')
		harpoon:setup({})

		-- basic telescope configuration
	    local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
    		local file_paths = {}
    		for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
    		end

    		require("telescope.pickers").new({}, {
        	    prompt_title = "Harpoon",
        	    finder = require("telescope.finders").new_table({
            	    results = file_paths,
        	    }),
        	    previewer = conf.file_previewer({}),
        	    sorter = conf.generic_sorter({}),
    	    }):find()
        end

        vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open harpoon window" })
	end
}
