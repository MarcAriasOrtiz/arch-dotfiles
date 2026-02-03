return { -- CONFIGURACION DE FORMATO
{
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform"
}, -- PLUGINS DE LSP
{
    "neovim/nvim-lspconfig",
    config = function()
        require "configs.lspconfig"
    end
}, -- PLIGINS DE Git
{
    "tpope/vim-fugitive",
    lazy = false -- Fugitive suele ser mejor tenerlo siempre a mano
}, {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    cmd = {"DiffviewOpen", "DiffviewFileHistory"}
}, -- Si quieres una interfaz tipo LazyGit pero dentro de Neovim
{
    "kdheepak/lazygit.nvim",
    cmd = {"LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile"},
    -- Opcional para integrarlo con Telescope
    dependencies = {"nvim-lua/plenary.nvim"}
}}
