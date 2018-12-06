{
  pkgs ? import <nixpkgs> {},
  pass
}:
pkgs.stdenv.mkDerivation {
  name = "dot-ssh";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/dot-ssh.sh \
        $out/bin/dot-ssh \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils pass ]} &&
      true
  '';
}
