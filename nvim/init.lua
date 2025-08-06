-- RUTA PARA LAZY.NVIM ------------------------
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

-- PLUGINS ------------------------------------
require("lazy").setup({
  -- LSP
  { "neovim/nvim-lspconfig" },

  -- Syntax Highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },

  -- Diagnostics
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Git
  { "lewis6991/gitsigns.nvim" },

  -- Folding
  { "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } }
})

-- LSP ----------------------------------------
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup({ capabilities = capabilities })
lspconfig.tsserver.setup({ capabilities = capabilities })

-- LSP Keybindings
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

-- TREESITTER ---------------------------------
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "python", "javascript" },
  highlight = { enable = true },
})

-- TELESCOPE ----------------------------------
require("telescope").setup({})
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)

-- CMP ----------------------------------------
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({}),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" }
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
})

-- LuaSnip ------------------------------------
require("luasnip.loaders.from_vscode").lazy_load()

-- TROUBLE ------------------------------------
require("trouble").setup({})
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)

-- GITSIGNS -----------------------------------
require("gitsigns").setup()

-- FOLDING ------------------------------------
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldenable = true

require("ufo").setup()
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

