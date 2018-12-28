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
  buildInputs = [ pkgs.bash pkgs.curl pkgs.nodejs pkgs.which pkgs.git ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/home &&
      export HOME=$out/home &&
      export GIT_SSL_NO_VERIFY=true &&
      export NODE_TLS_REJECT_UNAUTHORIZED=0 &&
      cp --recursive . $out/home &&
      cd $out/home &&
      sh ./scripts/install-sdk.sh &&
      curl -L https://raw.githubusercontent.com/c9/install/master/install.sh | bash &&
      true
  '';
}
