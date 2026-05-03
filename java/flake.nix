{
  description = "Java development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mkJavaShell =
        jdk:
        pkgs.mkShell {
          buildInputs = [
            jdk # open-source Java Development Kit
            pkgs.maven # build automation tool
            # utils
            pkgs.license-generator # CLI tool for generating license files
            pkgs.grex # a CLI tool for generating regular expressions from user-provided test cases
            pkgs.bitwise # terminal based bitwise calculator
            pkgs.just # a handy way to save and run project-specific commands
            pkgs.onefetch # CLI git information tool
            pkgs.scc # a very fast accurate code counter with complexity calculations
          ];

          JAVA_HOME = jdk;

          shellHook = ''
            export MAVEN_OPTS="-Dmaven.repo.local=$PWD/.m2"
            echo "> Using Java from: $JAVA_HOME"
            echo "> Java"
            java --version
            echo "> Javac"
            javac --version
            echo "> Maven"
            mvn --version
            echo "> Java dev environment ready!"
          '';
        };
    in
    {
      # nix develop .#jdk21 to use Java 21
      # nix develop to use default Java
      devShells.${system} = {
        jdk8 = mkJavaShell pkgs.jdk8;
        jdk17 = mkJavaShell pkgs.jdk17;
        jdk21 = mkJavaShell pkgs.jdk21;
        jdk25 = mkJavaShell pkgs.jdk25;

        default = mkJavaShell pkgs.jdk21;
      };
    };
}
