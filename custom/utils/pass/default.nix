{
  pkgs ? import <nixpkgs> {},
  name,
  uuid,
  origin-repository
}:
let
  pass = (import ../../../installed/pass/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "${name}";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/pass.sh \
        $out/bin/pass \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.docker gpass ]}
  '';
}
