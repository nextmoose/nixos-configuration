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
  implementation = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = name;
    src = src;
    dependencies = dependencies;
    configuration = configuration;
  });
  testing = {
    implementation = implementation;
    results = (import ./script-test.nix {
      implementation = implementation;
      test-script = test-script;
    });
    mutants = map (d: (builtins.tryEval (import ./script-test.nix {
      implementation = (import ./script-derivation.nix {
        pkgs = pkgs;
        name = name;
        src = src;
        dependencies = builtins.filter (x: x!=d) dependencies;
        configuration = configuration;
      });
      test-script = test-script;
    }))) dependencies;
  };
}
