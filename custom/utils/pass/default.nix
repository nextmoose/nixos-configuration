{
  pkgs ? import <nixpkgs> {},
  name
}:
pkgs.stdenv.mkDerivation {
  name = $name;
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ]
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/exec.sh \
        $out/bin/${name} \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} &&
  '';
}
