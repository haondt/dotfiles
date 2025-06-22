{ config, pkgs, nixpkgs-unstable, private,  ... }:


{
	home.username = private.username;
	home.homeDirectory = "/home/${private.username}";


	home.packages = with pkgs; [
		neofetch
		nixpkgs-unstable.neovim
	];
}
