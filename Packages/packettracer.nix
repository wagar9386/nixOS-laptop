{ pkgs, lib }:

pkgs.stdenv.mkDerivation {
  pname = "cisco-packet-tracer";
  version = "9.0.0";

  src = ./CiscoPacketTracer_900_Ubuntu_64bit.deb;

  nativeBuildInputs = [
    pkgs.dpkg
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';

  meta = {
    description = "Cisco Packet Tracer";
    homepage = "https://www.netacad.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
