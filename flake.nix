{
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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
    in flake // {
      packages.default = flake.packages."myprogram:exe:myprogram";
    });
}