```nix
  { pkgs, lib }:

  let
    packetTracerDeb = pkgs.requireFile {
      name = "CiscoPacketTracer_900_Ubuntu_64bit.deb";
      sha256 = "086r5qbvvf8qarp554j4q4044vgswv3xfzv2iyvdqdzwqzac16nx";
      message = ''
        Cisco Packet Tracer 9.0.0 is required.

        Download the .deb and add it to the Nix store with:

          nix-store --add-fixed sha256 ~/Downloads/CiscoPacketTracer_900_Ubuntu_64bit.deb
      '';
    };
  in

  pkgs.stdenv.mkDerivation {
    pname = "cisco-packet-tracer";
    version = "9.0.0";

    src = packetTracerDeb;

    nativeBuildInputs = [
      pkgs.dpkg
      pkgs.makeWrapper
    ];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/

      mkdir -p $out/bin

      makeWrapper \
        $out/opt/pt/packettracer \
        $out/bin/packettracer
    '';

    meta = {
      description = "Cisco Packet Tracer";
      homepage = "https://www.netacad.com/";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  }
```

