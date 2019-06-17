f: {
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs>{},
  ...
} @ args:

with import ../lib/testing.nix { inherit system pkgs; };

makeTest (if pkgs.lib.isFunction f then f (args // { inherit pkgs; inherit (pkgs) lib; }) else f)
