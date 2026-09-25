{ pkgs, lib }:

let
  appimage = pkgs.stdenvNoCC.mkDerivation {
    pname = "cisco-packet-tracer-appimage";
    version = "9.0.0";

    src = pkgs.requireFile {
      name = "CiscoPacketTracer_900_Ubuntu_64bit.deb";
      sha256 = "086r5qbvvf8qarp554j4q4044vgswv3xfzv2iyvdqdzwqzac16nx";
      message = ''
        Cisco Packet Tracer 9.0.0 is required.

        Add it to the Nix store with:

          nix-store --add-fixed sha256 ~/Downloads/CiscoPacketTracer_900_Ubuntu_64bit.deb
      '';
    };

    nativeBuildInputs = [
      pkgs.dpkg
    ];

    installPhase = ''
      cp opt/pt/packettracer.AppImage $out
    '';
  };
in

pkgs.appimageTools.wrapType2 rec {
  pname = "cisco-packet-tracer";
  version = "9.0.0";

  src = appimage;

  extraPkgs = _: [
    pkgs.libpng
    pkgs.libxkbfile
  ];

  extraBwrapArgs = [
    "--chdir"
    "/home/agar"
    "--setenv"
    "QT_QPA_PLATFORM"
    "xcb"
  ];

  extraInstallCommands =
    let
      contents = pkgs.appimageTools.extract {
        inherit pname version src;
      };
    in
    ''
      mv $out/bin/${pname} $out/bin/packettracer9
      ln -s $out/bin/packettracer9 $out/bin/packettracer

      install -Dm444 \
        ${contents}/CiscoPacketTracer-9.0.0.desktop \
        $out/share/applications/cisco-packet-tracer-9.desktop

      install -Dm444 \
        ${contents}/CiscoPacketTracerPtsa-9.0.0.desktop \
        $out/share/applications/cisco-packet-tracer-ptsa-9.desktop

      install -Dm444 \
        ${contents}/usr/share/icons/hicolor/48x48/apps/app.png \
        $out/share/icons/hicolor/48x48/apps/cisco-packet-tracer-9.png
    '';

  meta = {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
