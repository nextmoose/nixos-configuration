{pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "flash";
  src = pkgs.fetchurl {
    url = "https://fpdownload.adobe.com/pub/flashplayer/pdc/32.0.0.101/flash_player_ppapi_linux.x86_64.tar.gz";
    sha512 = "0zjyvhz9gal2ac1lqd4g51zwfhf5vfm84363jg3k3lk90pym97a68kf7syagj9aiv6lib78v9zx3nhnnmkimkpdv8jx3j919k2npj9r";
  };
  installPhase = ''
    mkdir $out &&
      ls -alh . &&
      cp --recursive . $out &&
      true
  '';
}
