local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Discord rich presence
	use("andweeb/presence.nvim")

	-- Linter and Formatter
	use("nvimtools/none-ls.nvim")
	use("jay-babu/mason-null-ls.nvim")

	-- Command Auto complete
	use("gelguy/wilder.nvim")

	-- Language packs
	use("sheerun/vim-polyglot")

	-- Auto pairs
	use("windwp/nvim-autopairs")

	-- The breadcrumbs
	use({
		"utilyre/barbecue.nvim",
		tag = "*",
		requires = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		after = "nvim-web-devicons", -- keep this if you're using NvChad
		config = function()
			require("barbecue").setup()
		end,
	})

	-- Status bar at the bottom
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	-- Telescope plugin
	use({
		"nvim-lua/plenary.nvim",
		"nvim-lua/popup.nvim",
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		"nvim-telescope/telescope-media-files.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Colour scheme
	use({ "rose-pine/neovim", as = "rose-pine" })

	-- Git decorations
	use("lewis6991/gitsigns.nvim")

	-- Syntax highlighting
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })

	-- Harpoon
	use("theprimeagen/harpoon")

	-- Undo tree
	use("mbbill/undotree")

	-- Control over GIT
	use("tpope/vim-fugitive")

	-- LSP snippets
	use("rafamadriz/friendly-snippets")
	use("L3MON4D3/LuaSnip")
	use("hrsh7th/cmp-nvim-lsp")
	use("saadparwaiz1/cmp_luasnip")

	-- LSP configuration
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/nvim-cmp",
	})

	-- LSP autocomplete
	use("ray-x/lsp_signature.nvim")

	-- auto tags
	use ("windwp/nvim-ts-autotag")

	-- TMUX Navigator
	use("christoomey/vim-tmux-navigator")

	-- Smooth Scroll
	use("karb94/neoscroll.nvim")

	-- SSH
	use("nosduco/remote-sshfs.nvim")

	-- Debug adapter
	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
	})

	use("theHamsta/nvim-dap-virtual-text")
	use("nvim-neotest/nvim-nio")
	use("mfussenegger/nvim-dap-python")
end)
