# ❄️ My nixOS dotfiles
*My NixOS configuration with Hyprland, Waybar, and a modular Home Manager setup. Feel free to look around and steal anything useful!*

![Desktop screenie](assets/screenshot.png)

## Info
| | |
|---|---|
| **OS** | NixOS unstable |
| **WM** | Hyprland |
| **Terminal** | Kitty |
| **Shell** | Bash |
| **Bar** | Waybar |
| **Launcher** | Rofi |
| **File Manager** | Ranger |
| **Theme** | Gruvbox Dark |
| **Font** | JetBrainsMono Nerd Font |
| **Browser** | Firefox |
| **Editor** | Vim |
| **Cursor** | Capitaine Cursors (Gruvbox) |
| **GPU** | NVIDIA (open kernel modules) | 

## Programs
| Program | Purpose |
|---|---|
| Vesktop | Discord client |
| Feishin | Music player (Navidrome) |
| Prismlauncher | Minecraft launcher |
| RetroArch | N64 emulator (Mupen64Plus core) |
| Steam | Game launcher |
| btop | System monitor |
| Flameshot + Swappy | Screenshots with annotation | 
| Blueman | Bluetooth manager |
| Pavucontrol | Audio control |
| Hyprpaper | Wallpaper daemon |
| Playerctl | Media control |
| Ranger | Terminal file manager |
| Dolphin | GameCube / Wii emulator |

## Keybinds
| Keybind | Action |
|---|---|
| `SUPER + Q` | Open terminal (Kitty) |
| `SUPER + C` | Close window |
| `SUPER + R` | Open launcher (Rofi) |
| `SUPER + E` | Open file manager (Ranger) |
| `SUPER + M` | Exit Hyprland |
| `SUPER + SHIFT + P` | Shutdown |
| `End` | Screenshot (region, swappy) |

## Waybar modules
Left: workspaces — Center: media player (click to play/pause, scroll to skip) — Right: volume, network IP, CPU (click → btop), RAM (click → btop), weather, clock, bluetooth 
## Structure
```
nixos-dotfiles/
├── flake.nix                  # Entry point, pins nixpkgs + home-manager + sops-nix
├── configuration.nix          # System-level config (NVIDIA, bluetooth, services, gc)
├── hardware-configuration.nix # DO NOT COPY — machine specific
├── .sops.yaml                 # sops age key config 
├── assets/
│   ├── screenshot.png
│   └── wallpapers/
├── secrets/
│   └── secrets.yaml           # Encrypted secrets — weather city, Navidrome creds 
├── home/
│   ├── default.nix            # Home Manager root (packages, bash, xdg dirs, imports)
│   ├── hyprland.nix           # Hyprland + hyprpaper symlinks
│   ├── waybar.nix             # Waybar config + media script
│   ├── kitty.nix              # Kitty symlinks
│   ├── rofi.nix               # Rofi symlinks
│   ├── swappy.nix             # Swappy config symlink
│   └── secrets.nix            # sops-nix secret declarations 
└── config/
    ├── hypr/
    │   ├── hyprland.lua       # Hyprland Lua config (Gruvbox, keybinds, monitors)
    │   └── hyprpaper.conf     # Wallpaper config
    ├── waybar/
    │   ├── config.jsonc       # Waybar modules
    │   ├── style.css          # Waybar Gruvbox theme
    │   └── scripts/
    │       ├── mediaplayer.py # Media player waybar script
    │       └── weather.sh     # Weather icon script — reads from sops secret 
    ├── kitty/
    │   ├── kitty.conf
    │   └── gruvbox.conf
    ├── rofi/
    │   └── config.rasi        # Rofi Gruvbox theme
    └── swappy/
        └── config             # Saves screenshots to ~/Pictures/screenies
```

## Commands
Rebuild and switch (from anywhere):
```bash
switch
```
Which expands to:
```bash
cd ~/nixos-dotfiles && sudo nixos-rebuild switch --flake .#goti-nixOS
```

Commit and push:
```bash
push "your commit message"
```

Update flake inputs (nixpkgs, home-manager, sops-nix):
```bash
nix flake update
switch
```

Edit encrypted secrets: 
```bash
sops secrets/secrets.yaml
```

## Secrets
This config uses [sops-nix](https://github.com/Mic92/sops-nix) with [age](https://github.com/FiloSottile/age) encryption to store secrets (weather location, Navidrome credentials) in the repo without exposing them in plaintext.

The encrypted `secrets/secrets.yaml` is safe to commit — it can only be decrypted with the private age key at `~/.config/sops/age/keys.txt` on your machine.

> ⚠️ **Back up your age key** (`~/.config/sops/age/keys.txt`). Losing it means permanently losing access to your secrets.

## Installation
Prerequisites: NixOS installed, flakes enabled.

> ⚠️ **Do NOT copy `hardware-configuration.nix`** — it's specific to my drives and will break your system.

```bash
git clone https://github.com/wagar9386/nixOS ~/nixos-dotfiles
cd ~/nixos-dotfiles
```

Generate your own hardware config:
```bash
sudo nixos-generate-config
cp /etc/nixos/hardware-configuration.nix ~/nixos-dotfiles/
```

Generate your own age key for secrets: 
```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

Update `.sops.yaml` with your new public key, then re-encrypt secrets with your own values:
```bash
sops secrets/secrets.yaml
```

Edit `flake.nix` and change `goti-nixOS` to your hostname, then:
```bash
sudo nixos-rebuild switch --flake .#yourHostname
```

## Tips 
- Nix store is auto-cleaned weekly — old generations deleted after 30 days
- `nix flake update` every few weeks for package updates — commit first so you can roll back with `git checkout flake.lock`
- If a switch breaks badly, boot a previous generation from the systemd-boot menu at startup
- Never edit `secrets/secrets.yaml` directly — always use `sops secrets/secrets.yaml`

## License
MIT — use or distribute freely.
