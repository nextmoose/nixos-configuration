{
  config,
  pkgs ? (import <nixpkgs> {}),
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
    staples.secrets
    staples.seed-secrets
  ];
  programs.bash.shellInit = ''
  '';
}
