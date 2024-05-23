return {
  {
    "theHamsta/nvim-dap-virtual-text",
    commit = "57f1dbd0458dd84a286b27768c142e1567f3ce3b",
    opts = {
      all_references = true,
      display_callback = function(variable, _, _, _, options)
        local value = variable.value
        if string.len(value) > 10 then
          return ""
        end

        if options.virt_text_pos == "inline" then
          return " = " .. value
        else
          return variable.name .. " = " .. value
        end
      end,
      enabled = true,
      only_first_definition = true,
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
    commit = "34160a7ce6072ef332f350ae1d4a6a501daf0159",
    config = function()
      require("dapui").setup()

      local dap_float = vim.api.nvim_create_augroup("dap_float", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "dap-float",
        group = dap_float,
        callback = function()
          vim.keymap.set("n", "q", vim.cmd.close)
        end,
      })
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    commit = "03bd29672d7fab5e515fc8469b7d07cc5994bbf6",
    dependencies = { "microsoft/vscode-js-debug" },
    opts = function()
      local utils = require("dap-vscode-js.utils")
      return {
        adapters = {
          "pwa-node",
          "pwa-chrome",
          "pwa-msedge",
          "node-terminal",
          "pwa-extensionHost",
        }, -- which adapters to register in nvim-dap
        debugger_path = utils.join_paths(utils.get_runtime_dir(), "lazy/vscode-js-debug"),
        -- log_file_level = vim.log.levels.TRACE,
        -- log_console_level = vim.log.levels.TRACE,
      }
    end,
  },
  {
    "microsoft/vscode-js-debug",
    commit = "8fa24a71b84043a3c7065e4c64e1a9541ec518b2",
    lazy = true,
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  {
    "mfussenegger/nvim-dap",
    commit = "13ce59d4852be2bb3cd4967947985cb0ceaff460",
    dependencies = { "rcarriga/nvim-dap-ui", "mfussenegger/nvim-dap", "mxsdev/nvim-dap-vscode-js" },
    config = function()
      local dap = require("dap")
      -- dap.set_log_level('TRACE')

      dap.configurations["lua"] = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }

      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      local firefoxPath = vim.fn.stdpath("data") .. "/mason/packages/firefox-debug-adapter"

      dap.adapters.firefox = {
        type = "executable",
        command = "node",
        args = { firefoxPath .. "/dist/adapter.bundle.js" },
      }

      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {

          -- {
          --   "type": "node",
          --   "runtimeVersion": "16.20.2",
          --   //"preLaunchTask": "clear-editor-history",
          --   //"urlFilter": "http://localhost:4200/*",
          --   "request": "launch",
          --   "outputCapture": "std",
          --   "name": "Launch via NPM",
          --   "runtimeExecutable": "npm",
          --   "sourceMapPathOverrides": {
          --     "webpack:/*": "${webRoot}/*"
          --   },
          --   "runtimeArgs": [
          --     "run-script",
          --     "debug"
          --   ],
          --   "port": 9229
          -- },

          {
            cwd = "${workspaceFolder}",
            name = "Launch via NPM",
            trace = false,
            outputCapture = "std",
            port = 9229,
            request = "launch",
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            runtimeArgs = {
              "run-script",
              "debug",
            },
            runtimeExecutable = "npm",
            skipFiles = {
              "<node_internals>/**",
            },
            smartStep = true,
            type = "pwa-node",
          },
          {
            name = "Firefox",
            pathMappings = {
              {
                url = "webpack:///assets",
                path = "${workspaceFolder}/assets",
              },
            },
            profileDir = "/Users/internship/Library/Application Support/Firefox/Profiles/184vonqb.default", -- platform specific :(
            request = "launch",
            skipFiles = {
              "<node_internals>/**",
            },
            timeout = 20,
            tmpDir = firefoxPath .. "/temp",
            type = "firefox",
            url = "http://localhost:1337/",
            webRoot = "${workspaceFolder}",
          },
          {
            name = "Chrome",
            type = "pwa-chrome",
            request = "launch",
            runtimeArgs = {
              "--profile-directory=debug-profile",
            },
            userDataDir = false,
            url = "http://localhost:1337",
            webRoot = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug backend tests",
            env = { NODE_ENV = "test" },
            program = "${workspaceFolder}/node_modules/mocha/bin/_mocha",
            runtimeArgs = {
              "--inspect",
            },
            args = {
              "--timeout",
              "999999",
              "--exit",
              "--full-trace",
              "-r",
              "source-map-support/register",
              "-r",
              "${workspaceFolder}/.src/test.bootstrap.js",
              "--recursive",
              "${workspaceFolder}/.src/test/tests",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
          },
          {
            name = "Attach frontend tests",
            port = 9222,
            request = "attach",
            type = "pwa-chrome",
            pathMapping = {
              ["/_karma_webpack_"] = "${workspaceFolder}",
            },
          },
          {
            console = "integratedTerminal",
            cwd = "${workspaceFolder}",
            name = "Launch frontend tests",
            outputCapture = "std",
            request = "launch",
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            runtimeArgs = {
              "run-script",
              "test:frontend:watch",
              "--",
              "--karma-config",
              vim.fn.fnamemodify(vim.fn.expand("$MYVIMRC"), ":h") .. "/after/plugin/vc-karma.js",
            },
            runtimeExecutable = "npm",
            skipFiles = {
              "<node_internals>/**",
            },
            smartStep = true,
            type = "pwa-node",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Toggle DAP UI",
      },
      {
        "<leader>dx",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate DAP session",
      },
      {
        "<leader>dd",
        function()
          require("dap").disconnect()
        end,
        desc = "Disconnect from DAP sesion",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue DAP session",
      },
      {
        "<leader>dR",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run DAP execution to cursor",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause DAP execution",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle DAP breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input({ prompt = "[Condition] > " }))
        end,
        desc = "Toggle conditional DAP breakpoint",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle DAP REPL",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle DAP REPL",
      },
      {
        "<leader>dE",
        function()
          -- This fine :h require("require("dap").ui").eval
          ---@diagnostic disable-next-line: missing-fields
          require("dapui").eval(vim.fn.input({ prompt = "[Expression] > " }), {})
        end,
        desc = "Evalute an expression",
      },
      {
        "<leader>de",
        function()
          -- This fine :h require("require("dap").ui").eval
          ---@diagnostic disable-next-line: missing-fields
          require("dapui").eval(nil, {})
        end,
        desc = "Evalute the word under the cursor",
      },
      {
        "<leader>dh",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.cursor_float(widgets.expression)
        end,
        desc = "Hover expression in float",
      },
      {
        "<leader>dH",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.expression)
        end,
        desc = "Hover expression in big float",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "DAP step into",
      },
      {
        "<leader>dv",
        function()
          require("dap").step_over()
        end,
        desc = "DAP step over",
      },
      {
        "<leader>dt",
        function()
          require("dap").step_out()
        end,
        desc = "DAP step out",
      },
    },
  },
}
