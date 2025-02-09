return {
	"mbbill/undotree",
	dependencies = {
		"pixelastic/vim-undodir-tree",
	},
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
	end
}
