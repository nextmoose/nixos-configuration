{
  pkgs ? import <nixpkgs> {},
  pass
}:
let
  gnupg = (import ../gnupg/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
  dot-ssh = (import ../dot-ssh/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
  gpg-key-id = (import ../../native/gpg-key-id/default.nix {
    pkgs = pkgs;
  });
in
stdenv.mkDerivation {
  name = "pass";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  install = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/pass.sh \
        $out/bin/pass \
        --set PATH ${pkgs.lib.makeBinPath [ gnupg dot-ssh gpg-key-id pkgs.pass ]} &&
      true
  ''
}
