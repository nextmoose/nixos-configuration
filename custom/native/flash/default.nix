{pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "flash";
  src = pkgs.fetchurl {
    name = "flash_player_ppapi_linux.x86_64.tar.gz";
    url = "https://get.adobe.com/flashplayer/download/?installer=FP_32.0_for_Linux_64-bit_(.tar.gz)-_PPAPI&sType=7436&standalone=1";
    sha512 = "231z9nvbmvd2hs83gnl6xbikyhm5ra1jka31394vdchwkahbwmp15j6kwxpb6y283swlyaf28bkdzycvlc2rdcsm07wp3izgk0k1z04";
  };
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out &&
      true
  '';
}
