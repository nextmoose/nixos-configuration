{
  pkgs,
  implementation,
  test-script
} :
let
  script-derivation = pkgs.writeShellScriptBin "bats" ''
    ${pkgs.bats}/bin/bats ${test-script} &&
      true
  '';
image = pkgs.dockerTools.buildImage {
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
};
in
pkgs.writeShellScriptBin "test-it" ''
  #!${pkgs.stdenv.shell}
  ${pkgs.docker}/bin/docker image load --input $image &&
    ${pkgs.docker}/bin/docker container run --interactive --tty --rm test &&
    true
'';