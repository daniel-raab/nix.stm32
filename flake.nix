{
  description = "Build a STM32 C project with Nix.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      pkgs = import nixpkgs { system = "x86_64-darwin";};
      system = "x86_64-darwin";
      buildTools = [pkgs.gcc-arm-embedded-13 pkgs.python311Packages.compiledb ];
      devTools = [
        pkgs.just
        pkgs.helix
      ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = buildTools ++ devTools;
      };
      packages.${system}.default = pkgs.clangSdtdenv.mkDerivation {
        name = "nix.stm32";
        packages = buildTools;
        src = self;
        buildPhase = "make";
        installPhase = ''
          mkdir -p $out/bin
          cp build/nix.stm32.elf $out/bin
        '';
      };
    };
}
