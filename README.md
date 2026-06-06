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

# Add wireguard client

full commands
```bash
NAME="strauss-full"
IP="10.0.0.4"
ALLOWED="0.0.0.0/0, ::/0"   # lan: 10.0.0.0/24  full: 0.0.0.0/0, ::/0
ENDPOINT="pouic.cc:51820"
SERVER_PUBKEY="6mdG3H+qsQEX0LGgeKDkZDlcIHeQF+ZYijethWDEWnc="

PRIVKEY=$(wg genkey)
PUBKEY=$(echo "$PRIVKEY" | wg pubkey)

sops --set "[\"${NAME}-wg-key\"] \"${PRIVKEY}\"" wireguard/keys.yaml
cat > "wireguard/configs/${NAME}.conf" <<EOF
[Interface]     
Address = ${IP}/24  
PrivateKey = PLACEHOLDER
DNS = 1.1.1.1

[Peer]
PublicKey = ${SERVER_PUBKEY}
Endpoint = ${ENDPOINT}
AllowedIPs = ${ALLOWED}
PersistentKeepalive = 25
EOF

echo "" 
echo "Add to wireguard/peers.nix:"
echo "    ${NAME} = {"
echo "      ip = \"${IP}\";"
echo "      publicKey = \"${PUBKEY}\";"
echo "    };"
```

generate qrcode
```bash
key=$(sops -d --extract "[\"${NAME}-wg-key\"]" wireguard/keys.yaml)
sed "s|PLACEHOLDER|$key|"  "wireguard/configs/${NAME}.conf" | qrencode -t ansiutf8
```

# TODO

- NixOS setup
- neovim setup
- alacritty setup

```
# Generate key pairs                                                                                                                                                                                         
  wg genkey | tee /tmp/mahler-lan.key | wg pubkey  # → put pubkey in peers.nix                                                                                                                                 
  wg genkey | tee /tmp/mahler-full.key | wg pubkey                                                                                                                                                             
                                                                                                                                                                                                               
  # Create sops secrets file                                                                                                                                                                                   
  sops hosts/Mahler/secrets/wireguard.yaml                                                                                                                                                                     
                                                                                                                                                                                                               
  Content for wireguard.yaml:                                                                                                                                                                                  
  mahler-lan-wg-key: "paste-private-key-here"                                                                                                                                                                  
  mahler-full-wg-key: "paste-private-key-here"                                                                                                                                                               
                                                                                                                                                                                                               
  Also make sure to add Mahler's age key to .sops.yaml so it can decrypt its own secrets.
```
