{ pkgs }:
{
  jdk,
  extraInputs ? [ ],
  extraShellHook ? "",
}:
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
  ]
  ++ extraInputs;

  JAVA_HOME = jdk;
  MAVEN_HOME = pkgs.maven;

  shellHook = ''
    echo ""
    echo "> Using Java from: $JAVA_HOME"
    echo "> Using Maven from: $MAVEN_HOME"
    echo "> Java"
    java --version
    echo "> Javac"
    javac --version
    echo "> Maven"
    mvn --version
  ''
  + extraShellHook
  + ''
    echo ""
    echo "*****************************"
    echo "> Java dev environment ready!"
    echo "*****************************"
  '';
}
