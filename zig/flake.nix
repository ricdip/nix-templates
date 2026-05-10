{
  description = "Zig development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    base = {
      url = "github:ricdip/nix-templates";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      base,
    }:
    let
      systems = base.systems;
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          f pkgs
        );
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            zig # general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software
            # zls # Zig LSP implementation + Zig Language Server

            # utils
            license-generator # CLI tool for generating license files
            grex # a CLI tool for generating regular expressions from user-provided test cases
            bitwise # terminal based bitwise calculator
            just # a handy way to save and run project-specific commands
            onefetch # CLI git information tool
            scc # a very fast accurate code counter with complexity calculations
          ];

          shellHook = ''

            echo ""
            echo "> Zig"
            zig version
            echo ""
            echo "****************************"
            echo "> Zig dev environment ready!"
            echo "****************************"
          '';
        };
      });
    };
}
