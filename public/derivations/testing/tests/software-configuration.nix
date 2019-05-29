import /nix/store/wl7y85xg46dsl5a7jjvqqdg1zbf678zn-nixos-18.03.133389.b551f89e256/nixos/nixos/tests/make-test.nix {
  machine = (import ../../../software-configuration.nix {
    config = {};
    pkgs = {};
  });
  testScript = ''
  '';
}