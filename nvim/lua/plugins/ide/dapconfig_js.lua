-- local dap = require("dap")

-- dap.set_log_level("DEBUG")

-- require("mason-nvim-dap").setup({
--     ensure_installed = { "js" },
--     automatic_installation = true,
-- })

-- require("dap-vscode-js").setup({
--     debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/",
--     adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
--     log_file_path = vim.fn.stdpath("cache") .. "/dap_vscode_js.log",
--     log_file_level = vim.log.levels.DEBUG,
--     log_console_level = vim.log.levels.DEBUG,
--     -- node_path = "node",
--     -- port = 9229,
--     -- debugger_cmd = {}
-- })


-- for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
--     if not dap.configurations[language] then
--         dap.configurations[language] = {}
--     end

--     -- table.insert(dap.configurations[language], {
--     --     name = "launch js",
--     --     type = "pwa-node",
--     --     request = "launch",
--     --     program = "${file}",
--     --     cwd = "${workspaceFolder}",
--     --     sourceMaps = true,
--     --     protocol = "inspector",
--     --     console = "integratedTerminal",
--     -- })

--     -- table.insert(dap.configurations[language], {
--     --     -- ts-nodeで実行（node v23, ts-node v11.0.0-beta.1）
--     --     name = "launch ts (ts-node)",
--     --     type = "pwa-node",
--     --     request = "launch",
--     --     runtimeExecutable = "node",
--     --     -- runtimeArgs = { "--inspect=localhost:9229", "--loader", "ts-node/esm", "${file}", },
--     --     runtimeArgs = { "--loader", "ts-node/esm", "${file}", },
--     --     skipFiles = { "<node_internals>/**", "node_modules/**" },
--     --     console = "integratedTerminal",
--     --     cwd = "${workspaceFolder}",
--     --     sourceMaps = true,
--     --     protocol = "inspector",
--     -- })

--     -- table.insert(dap.configurations[language], {
--     --     name = "launch ts (ts-node terminal)",
--     --     type = "node-terminal",
--     --     request = "launch",
--     --     command = "ts-node ${file}",
--     --     cwd = "${workspaceFolder}",
--     --     sourceMaps = true,
--     --     skipFiles = { "<node_internals>/**", "node_modules/**" },
--     -- })

--     -- table.insert(dap.configurations[language], {
--     --     name = "attach ts (manual)",
--     --     type = "pwa-node",
--     --     request = "attach",
--     --     -- デフォルトのデバッグポート
--     --     cwd = "${workspaceFolder}",
--     --     sourceMaps = true,
--     --     skipFiles = { "<node_internals>/**", "node_modules/**" },
--     --     localRoot = "${workspaceFolder}",
--     --     remoteRoot = "${workspaceFolder}",
--     --     autoAttachChildProcesses = false,
--     -- })

--     -- table.insert(dap.configurations[language], {
--     --     name = "launch ts (ts-node pwa env)",
--     --     type = "pwa-node",
--     --     request = "launch",
--     --     runtimeExecutable = "node", -- or full path to node
--     --     runtimeArgs = {
--     --         "/home/nag/.asdf/installs/nodejs/23.10.0/lib/node_modules/ts-node/dist/bin.js",
--     --         "${file}",
--     --     },
--     --     cwd = "${workspaceFolder}",
--     --     sourceMaps = true,
--     --     skipFiles = { "<node_internals>/**", "node_modules/**" },
--     --     console = "integratedTerminal",
--     --     env = {
--     --         -- NODE_OPTIONS = "--inspect" -- 開始時に停止しない場合
--     --         NODE_OPTIONS = "--inspect-brk" -- 開始時に停止する場合 (ポートはpwa-nodeが自動割当)
--     --     }
--     -- })

--     table.insert(dap.configurations[language], {
--         name = "launch - ts-node (NODE_OPTIONS)",
--         type = "pwa-node",
--         request = "launch",
--         runtimeExecutable = "node",
--         -- runtimeArgs = {
--         --     "/home/nag/.asdf/installs/nodejs/23.10.0/lib/node_modules/ts-node/dist/bin.js",
--         --     "${file}",
--         -- },

--         program = "${file}",
--         runtimeArgs = {
--             -- '-r', 'ts-node/register', -- CommonJS の場合
--             '--loader', 'ts-node/esm', -- ESM の場合
--         },

--         cwd = "${workspaceFolder}",
--         sourceMaps = true,
--         protocol = "inspector",
--         -- console = "integratedTerminal",
--         skipFiles = {
--             "<node_internals>/**",
--             "${workspaceFolder}/node_modules/**",
--         },
--         -- env = {
--         --     NODE_OPTIONS = "--inspect-brk"
--         -- },
--         autoAttachChildProcesses = false,
--     })
-- end
