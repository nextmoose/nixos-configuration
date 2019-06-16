{
  pkgs
}:
{
  name,
  src,
  dependencies ? [],
  configuration ? {},
  test-script
}:
rec {
  implementation = (./import script-derivation.nix {
    pkgs = pkgs;
    name = name;
    src = src;
    dependencies = dependencies;
    configuration = configuration;
  });
  testing = {
    results = (import ./script-test.nix {
      implementation = implementation;
      test-script = test-script;
    });
    mutants = map (d: (./import script-derivation.nix {
      pkgs = pkgs;
      name = name;
      src = src;
      dependencies = builtins.filter (x: x!=d) dependencies;
      configuration = configuration;
    }));
  };
}
