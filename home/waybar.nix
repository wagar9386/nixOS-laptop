{ config, pkgs, ... }:

  # Custom python environment with the required C-binding wrappers

  # Create an absolute path executable wrapper script
{
  programs.waybar = {
    enable = true;
  };
systemd.user.services.waybar = {
    Unit = {
        Description = "Waybar status bar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
    };
    Service = {
        Type = "simple";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
        RestartSec = 1;
    };
    Install = {
        WantedBy = [ "graphical-session.target" ];
    };
};
  # Symlink style and scripts
  xdg.configFile."waybar/style.css".source = ../config/waybar/style.css;
  xdg.configFile."waybar/scripts".source = ../config/waybar/scripts;

  # Let Home Manager manage config.jsonc directly so we can pass it the raw executable path
  xdg.configFile."waybar/config.jsonc".text = builtins.toJSON (
    (builtins.fromJSON (builtins.readFile ../config/waybar/config.jsonc)) // {
        # This replaces whatever "exec" you wrote with the bulletproof absolute Nix store path script
    }
  );

  home.packages = [ pkgs.playerctl ];

}
