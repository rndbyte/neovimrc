local utils = require("utils")

return {
    {
	    "nvim-treesitter/nvim-treesitter",
	    build = ":TSUpdate",
        event = { "VeryLazy" },
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        opts = {
  	    	-- A list of parser names, or "all" (the listed parsers should always be installed)
  	    	ensure_installed = {
          		"xml",
          		"html",
          		"json",
          		"yaml",
          		"make",
          		"css",
          		"vim",
          		"vimdoc",
          		"query",
          		"bash",
          		"lua",
          		"sql",
          		"markdown",
          		"dockerfile",
  	    	},

  	    	-- Install parsers synchronously (only applied to `ensure_installed`)
  	    	sync_install = false,

  	    	-- Automatically install missing parsers when entering buffer
  	    	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  	    	auto_install = true,

	    	indent = { enable = true },

  	    	highlight = {
        		enable = true,

        		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        		-- Using this option may slow down your editor, and you may see some duplicate highlights.
        		-- Instead of true it can also be a list of languages
        		additional_vim_regex_highlighting = { "markdown" },
  	    	},
        },
	    config = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                opts.ensure_installed = utils.dedup(opts.ensure_installed)
            end

            require("nvim-treesitter.configs").setup(opts)
	    end
    }
}
