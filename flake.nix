{
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix?ref=angerman/fix-aarch64-musl";
  # for caching you want to follow haskell.nix's nixpkgs-unstable pins.
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
    let
      overlays = [ haskellNix.overlay
        (final: prev: {
          myprogram =
            final.haskell-nix.project' {
              src = ./.;
              compiler-nix-name = "ghc964";
            };
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };
      # https://input-output-hk.github.io/haskell.nix/tutorials/cross-compilation.html
      flake = pkgs.pkgsCross.musl64.myprogram.flake {};
    in (pkgs.myprogram.flake {}) // {
      packages.default = flake.packages."myprogram:exe:myprogram";
    } // pkgs.lib.optionalAttrs (system == "x86_64-linux") {
      hydraJobs = (pkgs.myprogram.flake {}).hydraJobs // {
        x86_64-musl.myprogram = (pkgs.pkgsCross.musl64.myprogram.flake {}).packages."myprogram:exe:myprogram";
        aarch64-musl.myprogram = (pkgs.pkgsCross.aarch64-multiplatform-musl.myprogram.flake {}).packages."myprogram:exe:myprogram";
      };
    });
}