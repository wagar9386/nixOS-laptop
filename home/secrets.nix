{ config, pkgs, ... }:
{
    sops = {
        age.keyFile = "/home/agar/.config/sops/age/keys.txt";
        defaultSopsFile = ../secrets/secrets.yaml;
        defaultSymlinkPath = "/run/user/1000/secrets";
        defaultSecretsMountPoint = "/run/user/1000/secrets.d";
        secrets = {
            weather_city = {};
            navidrome_url = {};
            navidrome_user = {};
            navidrome_password = {};
            smb_credentials = {
   		 path = "/run/user/1000/secrets/smb_credentials";
   		 mode = "0400";
		};
        };
    };
}
