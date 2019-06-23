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
    results = (import ./docker-script-test.nix {
      pkgs = pkgs;
      implementation = implementation;
      test-script = test-script;
    });
  };
}
