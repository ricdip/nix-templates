{
  description = "Nix templates for development environments";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          f system pkgs
        );
    in
    {
      inherit systems;
      lib = forAllSystems (
        system: pkgs: {
          mkJavaShell = import ./lib/java-base-shell.nix { inherit pkgs; };
        }
      );
      templates = {
        # nix flake init -t .#java
        java = {
          path = ./java;
          description = "Java development environment";
        };
        # nix flake init -t .#java-spring
        java-spring = {
          path = ./java-spring;
          description = "Java development environment with Spring Boot";
        };
        # nix flake init -t .#system
        system = {
          path = ./system;
          description = "C/C++/NASM user-space development environment";
        };
        # nix flake init -t .#kernel
        kernel = {
          path = ./kernel;
          description = "C/C++/NASM kernel-space development environment";
        };
        # nix flake init -t .#python-poetry
        python-poetry = {
          path = ./python-poetry;
          description = "Python development environment with poetry";
        };
        # nix flake init -t .#go
        go = {
          path = ./go;
          description = "Go development environment";
        };
        # nix flake init -t .#rust
        rust = {
          path = ./rust;
          description = "Rust development environment";
        };
        # nix flake init -t .#zig
        zig = {
          path = ./zig;
          description = "Zig development environment";
        };
      };
    };
}
