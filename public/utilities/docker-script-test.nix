{
  pkgs,
  implementation ? pkgs.bc,
  bats-script ? ../bats/configure-nixos/hello.sh
} :
let
  script-derivation = pkgs.writeShellScriptBin "bats" ''
    ${pkgs.bats}/bin/bats ${bats-script} &&
      true
  '';
in
pkgs.dockerTools.buildImage {
  name = "test";
  runAsRoot = ''
    #!${pkgs.stdenv.shell}
    ${pkgs.dockerTools.shadowSetup}
    useradd user &&
      mkdir /tmp &&
      chmod 1777 /tmp &&
      true
  '';
  config = {
    Entrypoint = "${script-derivation}/bin/bats";
    User = "user";
  };
  contents = [ implementation script-derivation pkgs.coreutils pkgs.gnugrep pkgs.gnused ];
}