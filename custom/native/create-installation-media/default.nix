{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  validate-not-blank = (import ../validate-not-blank/default.nix {});
  alpha-pass = (import ../../user/alpha-pass/default.nix {});
in
stdenv.mkDerivation {
  name = "create-installation-media";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
      $out/scripts/create-installation-media.sh \
      $out/bin/create-installation-media \
      --set PATH ${lib.makeBinPath [ gnutar gzip coreutils virtualbox lvm2 "/run/wrappers" gnupg nix devicemapper bash validate-not-blank alpha-pass git ]} &&
      true
  '';
}
