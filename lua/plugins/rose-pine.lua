return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				respect_default_highlight_groups = true,
			})

			local palette = require("rose-pine.palette")

			-- to customize theme:
			-- :TSHighlightCapturesUnderCursor shows the highlight group of the element under the cursor
			-- highlight groups ~/.config/nvim/theme/rose-pine/lua/rose-pine.lua
			-- color palette    ~/.config/nvim/theme/rose-pine/lua/rose-pine/palette.lua

			-- sets the color scheme
			vim.cmd("colorscheme rose-pine-moon")

			-- highlight overwrite example for specific file type
			vim.api.nvim_create_augroup("FileTypeMarkdown", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = "FileTypeMarkdown",
				pattern = "markdown",
				callback = function()
					-- example
					vim.api.nvim_set_hl(0, "Normal", { fg = palette.text })
				end,
			})
		end,
	},
}
