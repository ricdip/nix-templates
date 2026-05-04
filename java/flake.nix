{
  description = "Java development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    base.url = "github:ricdip/nix-templates";
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
    in
    {
      # nix develop .#jdk21 to use Java 21
      # nix develop to use default Java
      devShells.${system} = {
        jdk8 = mkJavaShell { jdk = pkgs.jdk8; };
        jdk17 = mkJavaShell { jdk = pkgs.jdk17; };
        jdk21 = mkJavaShell { jdk = pkgs.jdk21; };
        jdk25 = mkJavaShell { jdk = pkgs.jdk25; };

        default = mkJavaShell { jdk = pkgs.jdk21; };
      };
    };
}
