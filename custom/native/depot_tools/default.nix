{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "depot_tools";
  src = pkgs.fetchgit {
    url = "https://chromium.googlesource.com/chromium/tools/depot_tools.git";
    rev = "41ae473398b528215aa41f553e467e2473231b49";
    sha256 = "1cw5fszffl5pkpa6s6wjnkiv6lm5k618s32sp60kvmvpy7a2v9kg";
  };
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    cp --recursive . $out &&
      true
  '';
}
