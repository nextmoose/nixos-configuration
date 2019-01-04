{pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "flash";
  src = pkgs.fetchurl {
    name = "flash_player_ppapi_linux.x86_64.tar.gz";
    url = "https://fpdownload.adobe.com/pub/flashplayer/pdc/32.0.0.101/flash_player_ppapi_linux.x86_64.tar.gz";
    sha512 = "231z9nvbmvd2hs83gnl6xbikyhm5ra1jka31394vdchwkahbwmp15j6kwxpb6y283swlyaf28bkdzycvlc2rdcsm07wp3izgk0k1z04";
  };
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out &&
      true
  '';
}
