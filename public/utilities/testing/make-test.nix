f: {
  system ? builtins.currentSystem,
  pkgs,
  ...
} @ args:

with import ./testing.nix { inherit system pkgs; };

makeTest (if pkgs.lib.isFunction f then f (args // { inherit pkgs; inherit (pkgs) lib; }) else f)
