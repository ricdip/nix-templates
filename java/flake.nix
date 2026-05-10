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
            mkJavaShell = base.lib.${system}.mkJavaShell;
            mkJavaCustomShell =
              jdk:
              mkJavaShell {
                inherit jdk;
                extraInputs = [
                  # pkgs.jetbrains.idea-oss # IntelliJ IDEA Community IDE
                ];
                extraShellHook = "";
              };

          in
          f system pkgs mkJavaCustomShell
        );
    in
    {
      # nix develop .#jdk21 to use Java 21
      # nix develop to use default Java
      devShells = forAllSystems (
        system: pkgs: mkJavaCustomShell: {
          jdk8 = mkJavaCustomShell pkgs.jdk8;
          jdk17 = mkJavaCustomShell pkgs.jdk17;
          jdk21 = mkJavaCustomShell pkgs.jdk21;
          jdk25 = mkJavaCustomShell pkgs.jdk25;

          default = mkJavaCustomShell pkgs.jdk21;
        }
      );
    };
}
