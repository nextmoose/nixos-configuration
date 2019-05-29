{
  config,
  pkgs ? (import <nixpkgs>{}),
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./public/software-configuration.nix
  ];
}
