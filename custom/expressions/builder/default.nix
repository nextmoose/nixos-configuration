{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  init-read-only-pass = (import ../../../installed/init-read-only-pass/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "builder";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp * $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/create-installation-image.sh $out/bin/create-installation-image --set PATH ${lib.makeBinPath [ gnutar gzip coreutils virtualbox lvm2 pass init-read-only-pass "/run/wrappers" gnupg nix ]} &&
      true
  '';
}
