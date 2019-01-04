{pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "flash";
  src = pkgs.fetchurl {
    url = "https://get.adobe.com/flashplayer/download/?installer=FP_32.0_for_Linux_64-bit_(.tar.gz)-_PPAPI&sType=7436&standalone=1";
    sha512 = "";
  };
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out &&
      true
  '';
}
