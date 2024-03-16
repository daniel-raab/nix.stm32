{
  description = "Build a STM32 C project with Nix.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-darwin =
    with import nixpkgs { system = "x86_64-darwin"; };
    stdenv.mkDerivation {
      name = "hello";
      src = self;
      buildPhase = "cc -o hello ./hello.c";
      installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
    };
  };
}
