{ config, pkgs, ... }:

{
    xdg.configFile."hypr/hyprland.lua".source = ../config/hypr/hyprland.lua;
    xdg.configFile."hypr/hyprpaper.conf".source = ../config/hypr/hyprpaper.conf;

    systemd.user.services.hyprpaper = {
        Unit = {
            Description = "Hyprpaper wallpaper daemon";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
            Restart = "on-failure";
            RestartSec = 1;
        };
        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
