{
  description = "Nix programming templates";

  outputs =
    { self }:
    {
      templates = {
        # nix flake init -t .#java
        java = {
          path = ./java;
          description = "Java development environment";
        };
        # nix flake init -t .#systems
        systems = {
          path = ./systems;
          description = "C/C++/NASM development environment";
        };
      };
    };
}
