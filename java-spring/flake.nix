{
  description = "Java development environment with Spring Boot";

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
            mkJavaShell = base.lib.${system}.mkJavaShell;
            mkJavaSpringShell =
              jdk:
              mkJavaShell {
                inherit jdk;
                extraInputs = [
                  pkgs.spring-boot-cli # CLI which makes it easy to create spring-based applications
                  # pkgs.jetbrains.idea-oss # IntelliJ IDEA Community IDE
                ];
                extraShellHook = ''
                  echo "> Spring Boot CLI:"
                  spring --version
                '';
              };
          in
          f system pkgs mkJavaSpringShell
        );

    in
    {
      # nix develop .#jdk21 to use Java 21
      # nix develop to use default Java
      devShells = forAllSystems (
        system: pkgs: mkJavaSpringShell: {
          jdk8 = mkJavaSpringShell pkgs.jdk8;
          jdk17 = mkJavaSpringShell pkgs.jdk17;
          jdk21 = mkJavaSpringShell pkgs.jdk21;
          jdk25 = mkJavaSpringShell pkgs.jdk25;

          default = mkJavaSpringShell pkgs.jdk21;
        }
      );
    };
}
