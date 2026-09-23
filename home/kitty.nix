{ config, pkgs, ... }:
{
xdg.configFile."kitty/kitty.conf".source = ../config/kitty/kitty.conf;
xdg.configFile."kitty/gruvbox.conf".source = ../config/kitty/gruvbox.conf;
}
