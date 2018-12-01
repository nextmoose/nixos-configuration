{
  pkgs ? import <nixpkgs> {},
  name ? "xchromium",
  version ? "44"
}:
let
  depot-tools = pkgs.stdenv.mkDerivation {
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
in
pkgs.stdenv.mkDerivation {
  name = "${name}-${version}";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper pkgs.coreutils ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      ln --symbolic ${pkgs.chromium}/bin/chromium $out/bin/${name} &&
      ln --symbolic ${pkgs.chromium}/bin/chromium $out/bin/aaaa &&
      makeWrapper ${pkgs.chromium}/bin/chromium $out/bin/bbbb &&
      true
  '';
}
