{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "depot_tools";
  src = pkgs.fetchgit {
    url = "https://chromium.googlesource.com/chromium/tools/depot_tools.git";
    rev = "Ic5029d6b12cdb6ea30704d90229ab7e365dc7273";
    sha256 = "1cw5fszffl5pkpa6s6wjnkiv6lm5k618s32sp60kvmvpy7a2v9kg";
  };
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    cp --recursive . $out &&
      true
  '';
}
