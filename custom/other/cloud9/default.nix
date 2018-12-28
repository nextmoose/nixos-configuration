{
  pkgs ? import <nixpkgs> {},
}:
pkgs.stdenv.mkDerivation {
  name = "cloud9";
  src = pkgs.fetchFromGithub {
    owner = "c9";
    repo = "core";
    rev = "c4d1c59dc8d6619bdca3dbe740291cd5cd26352c";
    sha256 = "25e6809f6fabf364c645430961bb3a02adc5b93f7bcdc8a41b692100cd0aa8bd";
  };
  installPhase = ''
    mkdir $out &&
      cp . $out &&
      cd $out &&
      sh ./scripts/install-sdk.sh &&
      true
  '';
}