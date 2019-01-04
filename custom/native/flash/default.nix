{pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "flash";
  src = pkgs.fetchurl {
    url = "https://fpdownload.adobe.com/pub/flashplayer/pdc/32.0.0.101/flash_player_ppapi_linux.x86_64.tar.gz";
    sha512 = "3ya8l87wxclv5ybchhxypzl8dxpd3jm7bnnpzmw6jplfqhbx24bvcl4vsy7yxzj55b1g63nw5w7vxi608k7ri4ql0madgbsrrc8zqb4";
  };
  installPhase = ''
    mkdir $out &&
      ls -alh . &&
      cp --recursive . $out &&
      true
  '';
}
