{
  config,
  pkgs ? (import <nixpkgs>{}),
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./custom/software-configuration.nix
  ];
}
