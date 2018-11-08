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
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/login-shell-init.sh $out/bin/login-shell-init --set PATH ${lib.makeBinPath [ coreutils ]} &&
      makeWrapper $out/scripts/nixos-container.sh $out/bin/nixos-container --set PATH ${lib.makeBinPath [ "/run/wrappers" nixos-container coreutils ]} &&
      makeWrapper $out/scripts/shell-init.sh $out/bin/shell-init --set PATH ${lib.makeBinPath [ coreutils ]} &&
      true
  '';
}
