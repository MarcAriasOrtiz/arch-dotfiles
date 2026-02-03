-- En options.lua
require "nvchad.options"

-- Usamos pcall (protected call) por si el plugin no ha cargado aún
local present, gitsigns = pcall(require, "gitsigns")
if present then
    gitsigns.setup {
        current_line_blame = true,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 500
        }
    }
end
