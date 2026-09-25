# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
#test

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "goti-portatil";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";





  programs.hyprland = {
    enable = true;
    xwayland.enable = true;

  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };


  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd 'uwsm start -- hyprland.desktop'";
      user = "agar";
    };
  };

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "ignore";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;

  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };
  };


  users.users.agar = {
    isNormalUser = true;
    extraGroups = [ "wheel" "vboxusers" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty
    git
    hyprpaper
    btop
    cmatrix
    fastfetch
    font-awesome
    neovim
    home-manager
    unzip
    python3
    fuse
    fuse3
    libpng
    openvpn
    (import ./Packages/packettracer.nix { inherit pkgs lib; })
  ];

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };


  #Only for devices on my home network
  fileSystems."/mnt/Casa" = {
    device = "//192.168.1.88/Casa";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},credentials=/run/user/1000/secrets/smb_credentials,uid=1000,gid=100" ];
  };



  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.deemix = {


    image = "ghcr.io/bambanah/deemix:latest";
    ports = [ "6595:6595" ];
    volumes = [
      "/home/agar/.config/deemix:/config"
      "/home/agar/Music:/downloads"
    ];
    environment = {
      DEEMIX_SINGLE_USER = "true";
      PUID = "1000";
      PGID = "100";
    };
  };

  virtualisation.virtualbox.host.enable = true;

  programs.gamemode.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  system.stateVersion = "26.05"; # Did you read the comment?

}

