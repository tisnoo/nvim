return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
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
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")

      lspconfig.tsserver.setup({
        require("typescript-tools").setup({
          code_lens = "off", -- need to patch a newer version of angularls to support them
          on_attach = on_attach,
          capabilities = capabilities,
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
      })
      lspconfig.solargraph.setup({
        capabilities = capabilities
      })
      lspconfig.html.setup({
        capabilities = capabilities
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
