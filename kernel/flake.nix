# TODO: work in progress
{
  description = "C/C++/NASM kernel-space development environment";

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
            hostPkgs = import nixpkgs { inherit system; };
            crossPkgs = hostPkgs.pkgsCross.gnu32;
          in
          f hostPkgs crossPkgs
        );
    in
    {
      devShells = forAllSystems (
        hostPkgs: crossPkgs: {
          default = hostPkgs.mkShell {
            packages = [
              # dev
              hostPkgs.gcc # GNU Compiler Collection
              hostPkgs.strace # System call tracer for Linux
              hostPkgs.ltrace # Library call tracer
              hostPkgs.man # Implementation of the standard Unix documentation system accessed using the man command
              hostPkgs.man-pages # Linux development manual pages
              hostPkgs.man-pages-posix # POSIX man-pages (0p, 1p, 3p)
              hostPkgs.gnumake # tool to control the generation of non-source files from sources (make)
              hostPkgs.binutils # tools for manipulating binaries (linker, assembler, etc.)

              crossPkgs.gcc # GNU Compiler Collection [cross compiling]
              crossPkgs.binutils # tools for manipulating binaries (linker, assembler, etc.) [cross compiling]
              # kernel
              hostPkgs.ncurses # Free software emulation of curses in SVR4 and more
              hostPkgs.flex # Fast lexical analyser generator
              hostPkgs.bison # Yacc-compatible parser generator
              hostPkgs.bc # GNU software calculator
              hostPkgs.libelf # ELF object file access library
              hostPkgs.openssl # Cryptographic library that implements the SSL and TLS protocols
              hostPkgs.syslinux # Lightweight bootloader
              hostPkgs.dosfstools # Utilities for creating and checking FAT and VFAT file systems

              hostPkgs.qemu # Generic and open source machine emulator and virtualizer
              hostPkgs.gdb # GNU Project debugger

              hostPkgs.nasm # 80x86 and x86-64 assembler

              # utils
              hostPkgs.license-generator # CLI tool for generating license files
              hostPkgs.grex # a CLI tool for generating regular expressions from user-provided test cases
              hostPkgs.bitwise # terminal based bitwise calculator
              hostPkgs.just # a handy way to save and run project-specific commands
              hostPkgs.onefetch # CLI git information tool
              hostPkgs.scc # a very fast accurate code counter with complexity calculations
            ];

            shellHook = ''
              echo "> Gcc"
              gcc --version
              echo "> Nasm"
              nasm -v
              echo "> C/C++/NASM kernel-space dev environment ready!"
            '';
          };
        }
      );
    };
}
