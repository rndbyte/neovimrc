function ColorMyPencils(color)
	color = color or "rose-pine-moon"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", {bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none" })
end

return {
	{
        'rose-pine/neovim',
        name = 'rose-pine',
        opts = {
			styles = {
				italic = false,
                transparency = false,
			}
		},
        config = function(_, opts)
			require("rose-pine").setup(opts)

            ColorMyPencils()
        end
	},
}
