{pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "flash";
  src = pkgs.fetchurl {
    name = "flash_player_ppapi_linux.x86_64.tar.gz";
    url = "https://get.adobe.com/flashplayer/download/?installer=FP_32.0_for_Linux_64-bit_(.tar.gz)-_PPAPI&sType=7436&standalone=1";
    sha512 = "9B71D224BD62F3785D96D46AD3EA3D73319BFBC2890CAADAE2DFF72519673CA72323C3D99BA5C11D7C7ACC6E14B8C5DA0C4663475C2E5C3ADEF46F73BCDEC043";
  };
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out &&
      true
  '';
}
