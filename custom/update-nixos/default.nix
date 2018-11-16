{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "update-nixos";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/update-nixos.sh $out/bin/update-nixos --set PATH ${lib.makeBinPath [ "/run/wrappers" "/run/current-system/sw" coreutils rsync mktemp ]} --set STORE_DIR $out &&
      true
  '';
}
