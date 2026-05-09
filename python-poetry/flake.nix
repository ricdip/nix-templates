{
  description = "Python development environment with poetry";

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
            poetry # Python dependency management and packaging made easy
            # used C libraries (for numpy)
            openblas
            stdenv.cc.cc.lib
            zlib

            # utils
            license-generator # CLI tool for generating license files
            grex # a CLI tool for generating regular expressions from user-provided test cases
            bitwise # terminal based bitwise calculator
            just # a handy way to save and run project-specific commands
            onefetch # CLI git information tool
            scc # a very fast accurate code counter with complexity calculations
          ];

          shellHook = ''
            export POETRY_VIRTUALENVS_IN_PROJECT=true
            export LD_LIBRARY_PATH=${
              pkgs.lib.makeLibraryPath [
                pkgs.stdenv.cc.cc.lib
                pkgs.openblas
                pkgs.zlib
              ]
            }:$LD_LIBRARY_PATH

            echo ""
            echo "> Poetry"
            poetry --version
            echo "- Use 'just poetry-init' to initialize a poetry environment"
            echo ""
            echo "*******************************************"
            echo "> Python dev environment with poetry ready!"
            echo "*******************************************"
          '';
        };
      });
    };
}
