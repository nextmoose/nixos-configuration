{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  init-read-only-pass = (import ../../../installed/init-read-only-pass/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "secrets";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/shell-init.sh $out/bin/shell-init --set PATH ${lib.makeBinPath [ coreutils pass init-read-only-pass ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/install-secret.sh $out/bin/install-secret --set PATH ${lib.makeBinPath [ mktemp gnutar coreutils gzip ]} --set INSTALL_DIR ${init-read-only-pass} &&
      makeWrapper $out/scripts/pass-secret.sh $out/bin/pass-secret --set PATH ${lib.makeBinPath [ coreutils mktemp pass ]} &&
      true
  '';
}
