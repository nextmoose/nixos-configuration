{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "depot_tools";
  src = pkgs.fetchgit {
    url = "https://chromium.googlesource.com/chromium/tools/depot_tools.git";
    rev = "61ea30737c65fb3a6ad7096f447465e58f8b915c";
    sha256 = "1pxrafl4prxa064l1ijra1ybxd26gqlqf6whkmj5nfwsvldsrnin";
  };
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    cp --recursive . $out &&
      true
  '';
}
