require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", {
    desc = "CMD enter command mode"
})
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Git Fugitive (El centro de control)
map("n", "<leader>gs", vim.cmd.Git, {
    desc = "Git Status (Fugitive)"
})
map("n", "<leader>gp", ":Git push<CR>", {
    desc = "Git Push"
})
map("n", "<leader>gl", ":Git pull<CR>", {
    desc = "Git Pull"
})

-- Diffview (Para revisar cambios visualmente)
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", {
    desc = "Diffview Open"
})
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", {
    desc = "File History"
})
map("n", "<leader>gx", "<cmd>DiffviewClose<cr>", {
    desc = "Diffview Close"
})

-- LazyGit (Si lo instalaste, es una joya visual)
map("n", "<leader>gg", "<cmd>LazyGit<cr>", {
    desc = "LazyGit Dashboard"
})
