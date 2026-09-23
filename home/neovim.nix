{ config, pkgs, ... }:
{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;

	extraPackages = with pkgs; [
	lua-language-server
	pyright
	typescript-language-server
	vscode-langservers-extracted
	rust-analyzer
	clang-tools
	nixd
	stylua
	black
	prettier
	nixpkgs-fmt
	ripgrep
	fd
];
		plugins = with pkgs.vimPlugins; [
			gruvbox-nvim
			lualine-nvim
			bufferline-nvim
			nvim-web-devicons
			plenary-nvim
			nui-nvim
			neo-tree-nvim
			telescope-nvim
			telescope-fzf-native-nvim
			nvim-treesitter.withAllGrammars
			nvim-lspconfig
			cmp-nvim-lsp
			cmp-buffer
			cmp-path
			luasnip
			cmp_luasnip
			nvim-cmp
			conform-nvim
			gitsigns-nvim
			trouble-nvim
			toggleterm-nvim
			which-key-nvim
			comment-nvim
			nvim-autopairs
			indent-blankline-nvim
		];
	};

	xdg.configFile."nvim/init.lua".source = ../config/neovim/init.lua;
}
