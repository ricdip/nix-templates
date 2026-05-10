{
  description = "C/C++/NASM user-space development environment";

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
          in
          f pkgs
        );
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            gcc # GNU Compiler Collection
            # clang # C language family frontend for LLVM (compiler)
            gnumake # tool to control the generation of non-source files from sources (make)
            cmake # cross-platform, open-source build system generator

            gdb # GNU Project debugger
            # gdbgui # browser-based frontend for GDB
            # lldb # next-generation high-performance debugger
            # valgrind # debugging and profiling tool suite
            # clang-tools # formatter, language server

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
            echo ""
            echo "> Gcc"
            gcc --version
            echo "> Nasm"
            nasm -v
            echo ""
            echo "**********************************************"
            echo "> C/C++/NASM user-space dev environment ready!"
            echo "**********************************************"
          '';
        };
      });
    };
}
