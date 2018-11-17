{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  secrets = (import ../temporary-secrets/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "create-install-media";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/create-install-media.sh $out/bin/create-install-media --set PATH ${lib.makeBinPath [ bash coreutils ]} --set SECRETS "${secrets}" &&
      true
  '';
}
