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
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mkJavaShell = base.lib.mkJavaShell;
      mkJavaSpringShell =
        jdk:
        mkJavaShell {
          inherit jdk;
          extraInputs = [
            pkgs.spring-boot-cli # CLI which makes it easy to create spring-based applications
          ];
          extraShellHook = ''
            echo "> Spring Boot CLI:"
            spring --version
          '';
        };
    in
    {
      # nix develop .#jdk21 to use Java 21
      # nix develop to use default Java
      devShells.${system} = {
        jdk8 = mkJavaSpringShell pkgs.jdk8;
        jdk17 = mkJavaSpringShell pkgs.jdk17;
        jdk21 = mkJavaSpringShell pkgs.jdk21;
        jdk25 = mkJavaSpringShell pkgs.jdk25;

        default = mkJavaSpringShell pkgs.jdk21;
      };
    };
}
