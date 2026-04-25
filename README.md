# Fedora Setup

```bash
sudo dnf install sway waybar wofi alacritty tar podman
curl -f https://zed.dev/install.sh | sh

# auto login
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo -ne '[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin user --noclear %I $TERM\n' |sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf

# install nix & home-manager
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
nix run home-manager/master -- init --switch

echo '/home/user/.nix-profile/bin/zsh' | sudo tee -a /etc/shells
chsh -s /home/user/.nix-profile/bin/zsh
sudo dnf install policycoreutils-python-utils
sudo semanage fcontext -a -t shell_exec_t '/nix/store/.*/bin/zsh'
```


# TODO

- NixOS setup
- neovim setup
- alacritty setup
