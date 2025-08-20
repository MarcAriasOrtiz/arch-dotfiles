require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "anakin_language_server", "qmlls", "bashls", "sqlls", "jsonls", "docker_compose_language_service" }

local lspconfig = require("lspconfig")

-- Cargar config custom de Anakin
lspconfig.anakin_language_server = require("custom.configs.anakin")

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
