{
  description = "A simple NixOS flake";
  inputs = {
	 	nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; 
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
};
	};
	outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ...}: let
private = import ~/dotfiles-private/gypsum/nixos/private.nix;
in {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
specialArgs = { pkgs-unstable = inputs.nixpkgs-unstable; };
			modules = [
				./configuration.nix

			home-manager.nixosModules.home-manager {
	
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${private.username} = import ./home.nix;
		home-manager.extraSpecialArgs = { inherit nixpkgs-unstable private; };

}
			];
		};

	};
}
