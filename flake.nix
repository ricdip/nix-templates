{
  description = "Nix programming templates";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mkJavaShell = import ./lib/java.nix { inherit pkgs; };
    in
    {
      lib = {
        mkJavaShell = mkJavaShell;
      };
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
        # nix flake init -t .#systems
        systems = {
          path = ./systems;
          description = "C/C++/NASM development environment";
        };
      };
    };
}
