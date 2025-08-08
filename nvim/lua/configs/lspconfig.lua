require("nvchad.configs.lspconfig").defaults()

-- Registrar el servidor lsp que se ha creado en csutom, Mason aun no tiene implmentado anakin_language_server
local lspconfig = require("lspconfig")
lspconfig.anakin_language_server = require("custom.configs.anakin")

local servers = { "html", "cssls", "anakin_language_server", "qmlls", "bashls", "sqlls", "jsonls", "docker_compose_language_service" }

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
