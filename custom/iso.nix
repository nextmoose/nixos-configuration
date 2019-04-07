{
  config,
  pkgs ? (import <nixpkgs> {}),
  secrets
  ...
}:
let
  staples = (import ./staples.nix{
    pkgs = pkgs;
  });
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  environment.systemPackages = [
    staples.foo
    (import ./create-assembly.nix {
      pkgs = pkgs;
      name = "secrets";
      src = secrets;
    })
  ];
  programs.bash.shellInit = ''
  '';
}
