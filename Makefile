mahler:
	home-manager switch --flake .#user@Mahler

strauss:
	home-manager switch --flake .#user@Strauss

bruckner:
	nixos-rebuild switch --flake .#Bruckner

bruckner-ssh:
	nix run nixpkgs#nixos-rebuild -- switch --flake --flake .#Bruckner --target-host root@pouic.cc --build-host root@pouic.cc
