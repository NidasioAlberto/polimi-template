{
  description = "Dev environment for Typst development";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    ...
  }: let
    # Helper function to apply an attribute set to all supported systems
    # forAllSystems :: (system -> AttrSet) -> AttrSet
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"];
  in {
    devShells = forAllSystems (system: {
      default = let
        pkgs = import nixpkgs {
          inherit system;
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
        };
      in
        pkgs.mkShell {
          packages = [
            # Nix
            pkgs.nil
            pkgs.alejandra

            # Typst compiler
            pkgs.typst

            # Typst formatter
            pkgs-unstable.typstyle
          ];
        };
    });
  };
}
