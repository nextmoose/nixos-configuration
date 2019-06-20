{
  pkgs,
  make-test
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
      pkgs = pkgs;
      make-test = make-test;
    });
  };
}
