{pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "flash";
  src = pkgs.fetchurl {
    url = "https://github.com/nextmoose/nixos-configuration/blob/level-4/custom/expressions/chromium/src/flash_player_ppapi_linux.x86_64.tar.gz?raw=true";
    sha512 = "3ya8l87wxclv5ybchhxypzl8dxpd3jm7bnnpzmw6jplfqhbx24bvcl4vsy7yxzj55b1g63nw5w7vxi608k7ri4ql0madgbsrrc8zqb4";
  };
  installPhase = ''
    mkdir $out &&
      ls -alh . &&
      cp --recursive . $out &&
      true
  '';
}
