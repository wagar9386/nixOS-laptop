{ config, pkgs, ... }:

{
    xdg.configFile."swappy/config".source = ../config/swappy/config;
}
