{
  config,
  pkgs ? (import <nixpkgs> {}),
  staples ? (import ./staples.nix{
    pkgs = pkgs;
  }),
  ...
}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  environment.systemPackages = [
    staples.foo
  ];
  programs.bash.shellInit = ''
  '';
}
