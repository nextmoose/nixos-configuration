{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation {
  name = "chromium";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/scripts &&
      makeWrapper \
        $out/scripts/chromium.sh \
        $out/bin/chromium \
        --set PATH ${lib.makeBinPath [ pkgs.chromium ]} &&
      true
  '';
}
