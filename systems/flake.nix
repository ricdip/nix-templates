{
  description = "C/C++/NASM development environment (user-space development)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          gcc # GNU Compiler Collection
          clang # C language family frontend for LLVM
          gnumake # tool to control the generation of non-source files from sources (make)
          cmake # cross-platform, open-source build system generator

          gdb # GNU Project debugger
          gdbgui # browser-based frontend for GDB
          # valgrind # debugging and profiling tool suite

          binutils # tools for manipulating binaries (linker, assembler, etc.)
          nasm # 80x86 and x86-64 assembler

          pkg-config # tool that allows packages to find out information about other packages

          # utils
          license-generator # CLI tool for generating license files
          grex # a CLI tool for generating regular expressions from user-provided test cases
          bitwise # terminal based bitwise calculator
          just # a handy way to save and run project-specific commands
          onefetch # CLI git information tool
          scc # a very fast accurate code counter with complexity calculations
        ];

        shellHook = ''
          echo "> Gcc"
          gcc --version
          echo "> Clang"
          clang --version
          echo "> Nasm"
          nasm -v
          echo "> C/C++/NASM dev environment ready!"
        '';
      };
    };
}
