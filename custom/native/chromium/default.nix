{
  pkgs ? import <nixpkgs> {},
  flash ? import ../flash/default.nix {
    pkgs = pkgs;
  }
}:
pkgs.stdenv.mkDerivation {
  name = "chromium";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/chromium.sh \
        $out/bin/chromium \
        --set FLASH_STORE ${flash} \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.chromium pkgs.coreutils pkgs.gnugrep ]} &&
      true
  '';
}
