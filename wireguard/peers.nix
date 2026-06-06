# Central WireGuard network configuration.
# All servers and clients import from here.
# Add public keys here; private keys stay in sops secrets on each host.
{
  # VPN subnet: 10.0.0.0/24
  # .1       bruckner (server)
  # .2-.3    mahler
  # .4-.5    phone
  # .10+     future vps servers

  servers = {
    bruckner = {
      endpoint = "pouic.cc:51820";
      ip = "10.0.0.1";
      # wg pubkey < /path/to/bruckner/private-key
      publicKey = "6mdG3H+qsQEX0LGgeKDkZDlcIHeQF+ZYijethWDEWnc=";
    };
    # future-vps = {
    #   endpoint = "vps2.example.com:51820";
    #   ip = "10.0.0.10";
    #   publicKey = "REPLACE_VPS2_PUBLIC_KEY=";
    # };
  };

  peers = {
    # mahler-lan = {
    #   ip = "10.0.0.2";
    #   # wg pubkey < ~/.config/wireguard/mahler-lan.key
    #   publicKey = "REPLACE_MAHLER_LAN_PUBLIC_KEY=";
    # };
    # mahler-full = {
    #   ip = "10.0.0.3";
    #   # wg pubkey < ~/.config/wireguard/mahler-full.key
    #   publicKey = "REPLACE_MAHLER_FULL_PUBLIC_KEY=";
    # };
    pixel9a-full = {
      ip = "10.0.0.2";
      publicKey = "sg8zxJregBzCsZcEfQv+qEB4P5O8UyW5f4M2DvzthjQ=";
    };
    pixel9a-lan = {
      ip = "10.0.0.3";
      publicKey = "7QwtF02DSQo9xnJOgGp8j15wHOP1hyACHyJpEMEaTz0=";
    };
    strauss-full = {
      ip = "10.0.0.4";
      publicKey = "oAtfvvLFEzymC1Z0AgkY/4OZUxvn0/+I+VriQOf6oh0=";
    };

  };
}
