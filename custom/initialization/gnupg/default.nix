{pkgs ? import <nixpkgs> {} }:
let
  pass = (import ../../../installed/pass.nix {
    pkgs = pkgs;
  });
in
pkgs.stdenv.mkDerivation {
  name = "gnupg";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/gnupg.sh \
        $out/bin/gnupg \
        --set PATH ${pkgs.lib.makeBinPath [ pass pkgs.gnupg pkgs.mktemp pkgs.coreutils ]} &&
      true
  '';
}
