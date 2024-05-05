local function get_npm_root()
	return vim.fn.system("npm root"):gsub("\n", "")
end

local function get_npm_global_root()
	return vim.fn.system("npm root -g"):gsub("\n", "")
end

local function append_node_modules(dir)
	return table.concat({ dir, "node_modules" }, "/") -- will probably cause problems on windows
end

local function angularls_config(workspace_dir)
	local root_dir = vim.loop.fs_realpath(".")
	local locations = table.concat(
		{ get_npm_global_root(), get_npm_root(), append_node_modules(root_dir), append_node_modules(workspace_dir) },
		","
	)

	return {
		"ngserver",
		"--stdio",
		"--tsProbeLocations",
		locations,
		"--ngProbeLocations",
		locations,
	}
end

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"nvim-lua/lsp-status.nvim",
		commit = "54f48eb5017632d81d0fd40112065f1d062d0629",
		config = function()
			require("lsp-status").register_progress()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		commit = "4eb8e15e3c0757303d4c6dea64d2981fc679e990",
		dependencies = {
			"williamboman/mason.nvim",
			"ibhagwan/fzf-lua",
			"neovim/nvim-lspconfig",
			"nvim-cmp",
			{
				"pmizio/typescript-tools.nvim",
				commit = "7911a0aa27e472bff986f1d3ce38ebad3b635b28",
				requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			},
		},
		config = function()
			local lsp_status = require("lsp-status")

			require("mason-lspconfig").setup_handlers({
				-- handle all servers without specific handlers
				function(server_name)
					require("lspconfig")[server_name].setup({
						on_attach = on_attach,
					})
				end,
				["clangd"] = function()
					require("lspconfig")["clangd"].setup({
						capabilities = lsp_status.capabilities,
						cmd = { "clangd", "--background-index", "--clang-tidy" },
					})
				end,
				["ltex"] = function()
					require("lspconfig")["ltex"].setup({
						on_attach = on_attach,
						settings = {
							ltex = {
								language = "en-GB",
								additionalRules = {
									enablePickyRules = true,
									motherTongue = "en-GB",
								},
								disabledRules = {
									["en-GB"] = { "OXFORD_SPELLING_NOUNS" },
								},
								checkFrequency = "save",
							},
						},
					})
				end,
				["tsserver"] = function()
					require("typescript-tools").setup({
						code_lens = "off", -- need to patch a newer version of angularls to support them
						on_attach = on_attach,
						capabilities = lsp_status.capabilities,
						settings = {
							complete_function_calls = true,
							expose_as_code_action = "all",
							tsserver_file_preferences = {
								importModuleSpecifierPreference = "relative",
								includeCompletionsForImportStatements = true,
								includeCompletionsForModuleExports = true,
								includeCompletionsWithSnippetText = true,
								includeInlayEnumMemberValueHints = true, -- enum {ONE /* = 0 */, TWO /* = 1 */,}
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayFunctionParameterTypeHints = false, -- no need for `.then(r /* ResultInterface[] */ => handleResult(r))`
								includeInlayParameterNameHints = "literals", -- only show inlay hints for literal values being passed
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								quotePreference = "single",
							},
							tsserver_format_options = {
								insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
							},
						},
					})
				end,
				["lua_ls"] = function()
					require("lspconfig")["lua_ls"].setup({
						capabilities = lsp_status.capabilities,
						on_attach = on_attach,
						settings = {
							Lua = {
								completion = { callSnippet = "Replace" },
								hint = {
									enable = true,
								},
								format = {
									enable = false,
								},
								-- Setup tailored for lua in neovim
								runtime = { version = "LuaJIT" },
								telemetry = { enable = false },
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
							},
						},
					})
				end,
				["ast_grep"] = function()
					require("lspconfig")["ast_grep"].setup({
						cmd = { "sg", "lsp" },
						filetypes = { "typescript", "pug" },
						single_file_support = true,
						root_dir = function()
							return vim.fn.fnamemodify(vim.fn.expand("$MYVIMRC"), ":h") .. "/misc/ast-grep"
						end,
					})
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		commit = "694aaec65733e2d54d393abf80e526f86726c988",
		config = function()
			local lsp_status = require("lsp-status")

			require("lspconfig")["angularls"].setup({
				on_attach = on_attach,
				capabilities = lsp_status.capabilities,
				filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "pug" },
				cmd = angularls_config(vim.loop.fs_realpath(".")),
				on_new_config = function(new_config, new_root_dir)
					new_config.cmd = angularls_config(new_root_dir)
				end,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		commit = "f20f35756e74b91c0b4340d01fee22422bdffefa",
		config = function()
			local lint = require("lint")

			require("lint").linters_by_ft = {
				scss = { "stylelint" },
				css = { "stylelint" },
				less = { "stylelint" },
			}
			local stylelint = require("lint").linters.stylelint
			stylelint.args = {
				"-f",
				"json",
				"--config",
				function()
					return vim.fn.fnamemodify(vim.fn.expand("$MYVIMRC"), ":h") .. "/stylelint.config.js"
				end,
				"--stdin",
				"--stdin-filename",
				function()
					return vim.fn.expand("%:p")
				end,
			}

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave", "TextChanged" }, {
				group = vim.api.nvim_create_augroup("lint", { clear = true }),
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
