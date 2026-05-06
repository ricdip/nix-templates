{
  description = "Nix templates for development environments";

  outputs =
    { self, nixpkgs }:
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
          mkJavaShell = import ./lib/java.nix { inherit pkgs; };
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
      };
    };
}
