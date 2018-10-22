{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "personal";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      mkdir $out/scripts &&
      cp shell-init.sh login-shell-init.sh $out/scripts &&
      chmod 0500 $out/scripts/shell-init.sh $out/scripts/login-shell-init.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/shell-init.sh $out/bin/shell-init --set PATH ${lib.makeBinPath [ coreutils ]} &&
      makeWrapper $out/scripts/login-shell-init.sh $out/bin/login-shell-init --set PATH ${lib.makeBinPath [ coreutils ]} &&
      true
  '';
}
