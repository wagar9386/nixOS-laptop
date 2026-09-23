vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.opt
o.number = true
o.relativenumber = true
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = false
o.smartindent = true
o.wrap = false
o.swapfile = false
o.termguicolors = true
o.signcolumn = "yes"
o.scrolloff = 8
o.updatetime = 200
o.cursorline = true
o.splitright = true
o.splitbelow = true
o.clipboard = "unnamedplus"
o.ignorecase = true
o.smartcase = true

vim.cmd("colorscheme gruvbox")

require("lualine").setup({ options = { theme = "gruvbox" } })
require("bufferline").setup({})

require("neo-tree").setup({})
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")

local tb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tb.find_files)
vim.keymap.set("n", "<leader>fg", tb.live_grep)
vim.keymap.set("n", "<leader>fb", tb.buffers)
vim.keymap.set("n", "<leader>fh", tb.help_tags)

require("nvim-treesitter").setup()
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- LSP (new vim.lsp.config/enable API, not the deprecated lspconfig[server].setup())
require("lspconfig") -- registers default server configs
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.enable({
	"lua_ls", "pyright", "ts_ls", "rust_analyzer",
	"clangd", "nixd", "html", "cssls",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr }) end
		map("n", "gd", vim.lsp.buf.definition)
		map("n", "gr", vim.lsp.buf.references)
		map("n", "K", vim.lsp.buf.hover)
		map("n", "<leader>rn", vim.lsp.buf.rename)
		map("n", "<leader>ca", vim.lsp.buf.code_action)
		map("n", "<leader>d", vim.diagnostic.open_float)
		map("n", "[d", vim.diagnostic.goto_prev)
		map("n", "]d", vim.diagnostic.goto_next)
	end,
})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args) require("luasnip").lsp_expand(args.body) end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		nix = { "nixpkgs_fmt" },
	},
	format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

require("gitsigns").setup()

require("trouble").setup({})
vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<CR>")

require("toggleterm").setup({})
vim.keymap.set("n", "<C-\\>", ":ToggleTerm<CR>")

require("which-key").setup({})
require("Comment").setup()
require("nvim-autopairs").setup()
require("ibl").setup()
