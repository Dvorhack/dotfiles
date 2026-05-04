
ARCH := $(uname -m)


mahler:
	home-manager switch --flake .#user@Mahler

strauss:
	home-manager switch --flake .#user@Strauss

bruckner:
	nix run nixpkgs#nixos-rebuild -- switch --flake --flake .#Bruckner

ifeq ($(ARCH),x86_64)
bruckner-ssh:
	nix run nixpkgs#nixos-rebuild -- switch --flake --flake .#Bruckner --target-host root@pouic.cc
else
bruckner-ssh:
	nix run nixpkgs#nixos-rebuild -- switch --flake --flake .#Bruckner --target-host root@pouic.cc --build-host root@pouic.cc
endif
