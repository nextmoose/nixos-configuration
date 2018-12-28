{
  pkgs ? import <nixpkgs> {},
}:
let
  node = (import ../../native/node/default.nix {
    pkgs = pkgs;
  });
in
pkgs.stdenv.mkDerivation {
  name = "cloud9";
  src = pkgs.fetchFromGitHub {
    owner = "c9";
    repo = "core";
    rev = "c4d1c59dc8d6619bdca3dbe740291cd5cd26352c";
    sha256 = "1q3h3nhrip4bclm627n8k8g0jgpnfl840ipv8kphn4q413qzcyc7";
  };
  buildInputs = [ pkgs.wget pkgs.curl node pkgs.which pkgs.git ];
  buildPhase = ''
    ./scripts/install-sdk.sh &&
      true
  '';
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out &&
      true
  '';
}