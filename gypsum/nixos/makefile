switch:
	(set -a && \
		source /home/$$USER/dotfiles-private/gypsum/nixos/.env && \
		sudo --preserve-env=NIXOS_PRIVATE_PATH nixos-rebuild switch -I nixos-config=/home/$$USER/dotfiles/gypsum/nixos/configuration.nix --show-trace);

.PHONY: load-env switch

