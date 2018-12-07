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
  gnupg-key-id = (import ../../native/gnupg-key-id/default.nix {
    pkgs = pkgs;
  });
  post-commit = (import ../../native/post-commit/default.nix {
    pkgs = pkgs;
  });
in
pkgs.stdenv.mkDerivation {
  name = "lighttable";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/lighttable.sh \
        $out/bin/lighttable \
        --set PATH ${pkgs.lib.makeBinPath [ gnupg dot-ssh gnupg-key-id pkgs.which pkgs.coreutils pkgs.gnugrep pkgs.findutils post-commit pkgs.lighttable ]} &&
      true
  '';
}
