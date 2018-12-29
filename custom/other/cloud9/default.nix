{
  pkgs ? import <nixpkgs> {},
}:
let
  node = (import ../../native/node/default.nix {
    pkgs = pkgs;
  });
  insecure-curl = (import ../../utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "curl";
    src = ../../scripts/insecure-curl;
    dependencies = [ pkgs.curl ];
  });
  install-it = (import ../../utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "install-it";
    src = ./install;
    dependencies = [ insecure-curl pkgs.which node python tmux gnumake ];
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
  buildInputs = [ pkgs.bash pkgs.curl pkgs.nodejs pkgs.which pkgs.git pkgs.python pkgs.which pkgs.tree install ];
  buildPhase = ''
    export HOME=. &&
      export GIT_SSL_NO_VERIFY=true &&
      export NODE_TLS_REJECT_UNAUTHORIZED=0 &&
      sh ./scripts/install-sdk.sh &&
      curl --insecure --output install.sh -L https://raw.githubusercontent.com/c9/install/master/install.sh &&
      install-it &&
      true
  '';
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out/c9sdk &&
      mkdir $out/bin &&
      touch $out/bin/findme &&
      chmod a+rx $out/bin/findme &&
      true
  '';
}
