{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/haskell-updates";

  outputs = { self, nixpkgs, ... }@inputs: let
    systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    forAllSystems = f: builtins.listToAttrs (map (name: { inherit name; value = f name; }) systems);
  in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          hlib = pkgs.haskell.lib;
          staticHaskellPackages = pkgs.pkgsStatic.haskell.packages.ghc98.override {
            overrides = hfinal: hprev: {
              myprogram = hfinal.callCabal2nix "myprogram" ./. { };
            };
          };
        in {
          default = staticHaskellPackages.myprogram;
        });
    };
}
