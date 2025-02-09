return {
    {
	    "neovim/nvim-lspconfig",
	    dependencies = {
	    	"williamboman/mason.nvim",
	    	"hrsh7th/nvim-cmp",
	    	"hrsh7th/cmp-buffer",
	    	"hrsh7th/cmp-path",
	    	"hrsh7th/cmp-cmdline",
	    	"saadparwaiz1/cmp_luasnip",
	    	"L3MON4D3/LuaSnip",
	    	"j-hui/fidget.nvim",
	    },
	    config = function()
	    	local cmp = require("cmp")

	    	require("fidget").setup({})
	    	require("mason").setup()

	    	local cmp_select = { behavior = cmp.SelectBehavior.Select }

	    	cmp.setup({
	    		snippet = {
            		expand = function(args)
                		require('luasnip').lsp_expand(args.body)
            		end,
        		},
	    		mapping = cmp.mapping.preset.insert({
	    			['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	    			['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	    			['<C-y>'] = cmp.mapping.confirm({ select = true }),
	    			['<C-Space>'] = cmp.mapping.complete(),
	    		}),
	    		sources = cmp.config.sources({
                    { name = 'lazydev', group_index = 0 },
	    			{ name = 'nvim_lsp' },
	    			{ name = 'luasnip' },
	    		}, {
	    			{ name = 'buffer' },
	    		}),
	    	})

	    	vim.diagnostic.config({
                float = {
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })
	    end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = {
	    	"hrsh7th/cmp-nvim-lsp",
        },
        opts = {
	    	ensure_installed = {
	    		'phpactor',
	    		'gopls',
                'golangci_lint_ls',
	    		'ts_ls',
	    		'lua_ls',
	    	},
	    	handlers = {
            	-- this first function is the "default handler"
            	-- it applies to every language server without a "custom handler"
            	function(server_name)
                    local cmp_lsp = require("cmp_nvim_lsp")
                    local capabilities = vim.tbl_deep_extend(
                        "force",
                        {},
                        vim.lsp.protocol.make_client_capabilities(),
                        cmp_lsp.default_capabilities()
                    )

            		require('lspconfig')[server_name].setup({
	    			    capabilities = capabilities
	    		    })
            	end,

            	-- this is the "custom handler" for `lua_ls`
	    		["lua_ls"] = function()
                    local cmp_lsp = require("cmp_nvim_lsp")
                    local capabilities = vim.tbl_deep_extend(
                        "force",
                        {},
                        vim.lsp.protocol.make_client_capabilities(),
                        cmp_lsp.default_capabilities()
                    )
	    			local lspconfig = require("lspconfig")
	    			lspconfig.lua_ls.setup({
	    				capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    -- See https://github.com/folke/lazydev.nvim/discussions/42
                                    -- With lazydev you should defintely not configure any globals.
                                    -- globals = { "vim", "it", "describe", "before_each", "after_each" },
                                },
                                runtime = {
                                    version = "LuaJIT",
                                },
                                workspace = {
                                    library = {
                                        -- Make the server aware of Neovim runtime files
                                        vim.fn.expand("$VIMRUNTIME/lua"),
                                        vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                                    },
                                    checkThirdParty = false,
                                    -- Skip files larger than 1000KB when preloading
                                    preloadFileSize = 1000,
                                },
                            }
                        }
	    			})
	    		end,
	    	}
        },
        config = function (_, opts)
            require('mason-lspconfig').setup(opts)
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "lazy.nvim", words = { "LazyUtil" } },
            },
        },
    },
}
