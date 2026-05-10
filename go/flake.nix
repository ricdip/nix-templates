{
  description = "Go development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    base = {
      url = "github:ricdip/nix-templates";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      base,
      ...
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
            go # Go Programming language
            gotools # additional tools for Go development
            delve # debugger for the Go programming language
            # gdlv # GUI frontend for Delve
            # gopls # language server

            # utils
            license-generator # CLI tool for generating license files
            grex # a CLI tool for generating regular expressions from user-provided test cases
            bitwise # terminal based bitwise calculator
            just # a handy way to save and run project-specific commands
            onefetch # CLI git information tool
            scc # a very fast accurate code counter with complexity calculations
          ];

          shellHook = ''
            export GOPATH=$PWD/.go
            export GOMODCACHE=$GOPATH/pkg/mod
            export PATH=$GOPATH/bin:$PATH

            echo ""
            echo "> Go"
            go version
            echo ""
            echo "***************************"
            echo "> Go dev environment ready!"
            echo "***************************"
            export PS1="$PS1 (go): "
          '';
        };
      });
    };
}
