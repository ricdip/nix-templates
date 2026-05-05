{
  description = "Java development environment";

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
          f system pkgs
        );
    in
    {
      # nix develop .#jdk21 to use Java 21
      # nix develop to use default Java
      devShells = forAllSystems (
        system: pkgs: {
          jdk8 = base.lib.${system}.mkJavaShell { jdk = pkgs.jdk8; };
          jdk17 = base.lib.${system}.mkJavaShell { jdk = pkgs.jdk17; };
          jdk21 = base.lib.${system}.mkJavaShell { jdk = pkgs.jdk21; };
          jdk25 = base.lib.${system}.mkJavaShell { jdk = pkgs.jdk25; };

          default = base.lib.${system}.mkJavaShell { jdk = pkgs.jdk21; };
        }
      );
    };
}
