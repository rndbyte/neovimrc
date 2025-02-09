return {
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
	    dependencies = {
            "mfussenegger/nvim-dap",
	    	"nvim-neotest/nvim-nio",
	    },
        opts = {
	        force_buffers = true,
	        layouts = {
	        	{
	        		elements = {
	        			{
	        				id = "scopes",
	        				size = 0.770,
	        			},
	        			{
	        				id = "repl",
	        				size = 0.230,
	        			},
	        		},
	        		position = "bottom",
	        		size = 10,
	        	},
	        	{
	        		elements = {
	        			{
	        				id = "breakpoints",
	        				size = 0.5,
	        			},
	        			{
	        				id = "stacks",
	        				size = 0.5,
	        			},
	        		},
	        		position = "left",
	        		size = 40,
	        	},
	        },
        },
	    config = function(_, opts)
            local dap, dapui = require('dap'), require('dapui')

	    	vim.fn.sign_define('DapBreakpoint', {
	    	    text = '⬤',
	    	    texthl = 'ErrorMsg',
	    	    linehl = '',
	    	    numhl = 'ErrorMsg'
	    	})

	    	vim.fn.sign_define('DapBreakpointCondition', {
	    	    text = '⬤',
	    	    texthl = 'ErrorMsg',
	    	    linehl = '',
	    	    numhl = 'SpellBad'
	    	})

	    	dapui.setup(opts)

	    	vim.keymap.set('n', '<F5>', function() dap.continue() end)
	    	vim.keymap.set('n', '<F10>', function() dap.step_over() end)
	    	vim.keymap.set('n', '<F11>', function() dap.step_into() end)
	    	vim.keymap.set('n', '<F12>', function() dap.step_out() end)
	    	vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
            vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint() end)
            vim.keymap.set('n', '<leader>dlp', function()
                dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
            end)
	    	vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end)
	    	vim.keymap.set('n', '<leader>dl', function() dap.run_last() end)

	    	vim.keymap.set({'n', 'v'}, '<leader>dh', function()
                require('dap.ui.widgets').hover()
	    	end)

	    	vim.keymap.set({'n', 'v'}, '<leader>dp', function()
                require('dap.ui.widgets').preview()
	    	end)

            vim.keymap.set('n', '<leader>df', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.frames)
            end)

            vim.keymap.set('n', '<Leader>ds', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.scopes)
            end)

            vim.keymap.set('n', '<leader>dc', function()
                dap.clear_breakpoints()
            end)

            vim.keymap.set('n', '<leader>dt', function()
                dap.terminate()
            end)

	    	dap.listeners.after.event_initialized["dapui_config"] = function()
	    	    dapui.open({ reset = true })
	    	end

            -- Some adapters may dispatch only "Thread" event while remote debugging (e.g. php-debug-adapter).
            dap.listeners.after.event_thread["dapui_config"] = function (_, body)
                if body.reason == "exited" then
                    dapui.close()
                end
            end

	    	dap.listeners.after.event_terminated["dapui_config"] = function()
	    	    dapui.close()
	    	end

	    	dap.listeners.after.event_exited["dapui_config"] = function()
	    	    dapui.close()
	    	end
	    end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            ensure_installed = {},
            handlers = {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end,
            },
        },
    },
    {
        "leoluz/nvim-dap-go",
        ft = "go",
    }
}
