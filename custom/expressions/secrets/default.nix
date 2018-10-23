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
      makeWrapper $out/scripts/pass-secret.sh $out/bin/pass-secret --set PATH ${lib.makeBinPath [ "$out" coreutils mktemp pass gnupg ]} &&
      makeWrapper $out/scripts/initialize.sh $out/bin/initialize --set PATH ${lib.makeBinPath [ gnutar gzip coreutils mktemp pass gnupg ]} --set INSTALL_DIR "${init-read-only-pass}" &&
      makeWrapper $out/scripts/init-project.sh $out/bin/init-project --set PATH ${lib.makeBinPath [ git coreutils ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/init-pass.sh $out/bin/init-pass --set PATH ${lib.makeBinPath [ git coreutils gnupg pass ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/post-commit.sh $out/scripts/post-commit --set PATH ${lib.makeBinPath [ git coreutils ]} &&
      true
  '';
}
