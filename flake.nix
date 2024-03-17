{
  description = "Build a STM32 C project with Nix.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      pkgs = import nixpkgs { system = "x86_64-darwin";};
      system = "x86_64-darwin";
      buildTools = [pkgs.gcc-arm-embedded-13 ];
      devTools = [pkgs.just];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = buildTools ++ devTools;
      };
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "nix.stm32";
        packages = buildTools;
        src = self;
        buildPhase = "make build";
        installPhase = ''
          mkdir -p $out/bin
          cp build/blinky.elf $out/bin
        '';
      };
    };
}
