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
            crossPkgs = hostPkgs.pkgsCross.gnu32; # i686-unknown-linux-gnu-gcc
            staticPkgs = hostPkgs.pkgsCross.musl64; # x86_64-unknown-linux-musl-gcc
          in
          f hostPkgs crossPkgs staticPkgs
        );
    in
    {
      devShells = forAllSystems (
        hostPkgs: crossPkgs: staticPkgs: {
          default = hostPkgs.mkShell {
            packages = [
              # dev
              hostPkgs.strace # system call tracer for Linux
              hostPkgs.ltrace # library call tracer
              hostPkgs.man # implementation of the standard Unix documentation system accessed using the man command
              hostPkgs.man-pages # linux development manual pages
              hostPkgs.man-pages-posix # POSIX man-pages (0p, 1p, 3p)
              hostPkgs.gnumake # tool to control the generation of non-source files from sources (make)
              hostPkgs.gcc # GNU Compiler Collection
              hostPkgs.binutils # tools for manipulating binaries (linker, assembler, etc.)

              crossPkgs.gcc # GNU Compiler Collection [cross compiling]
              crossPkgs.binutils # tools for manipulating binaries (linker, assembler, etc.) [cross compiling]
              staticPkgs.gcc # GNU Compiler Collection [static linking]
              staticPkgs.binutils # tools for manipulating binaries (linker, assembler, etc.) [static linking]

              # kernel
              hostPkgs.ncurses # free software emulation of curses in SVR4 and more
              hostPkgs.flex # fast lexical analyser generator
              hostPkgs.bison # Yacc-compatible parser generator
              hostPkgs.bc # GNU software calculator
              hostPkgs.elfutils # set of utilities to handle ELF objects
              hostPkgs.openssl # cryptographic library that implements the SSL and TLS protocols
              hostPkgs.syslinux # lightweight bootloader
              hostPkgs.dosfstools # utilities for creating and checking FAT and VFAT file systems

              hostPkgs.qemu # generic and open source machine emulator and virtualizer
              hostPkgs.gdb # GNU Project debugger
              hostPkgs.pkg-config # tool that allows packages to find out information about other packages

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
              set-libelf() {
                export CFLAGS="$(pkg-config --cflags libelf)"
                export LDFLAGS="$(pkg-config --libs libelf)"
                export HOSTCFLAGS="$CFLAGS"
                export HOSTLDFLAGS="$LDFLAGS"
              } 

              unset-libelf() {
                unset CFLAGS
                unset LDFLAGS
                unset HOSTCFLAGS
                unset HOSTLDFLAGS
              }

              make-static() {
                make CC=x86_64-unknown-linux-musl-gcc -j$(nproc)
              }

              make-x86_64() {
                make -j$(nproc)
              }

              make-i686() {
                make CC=i686-unknown-linux-gnu-gcc -j$(nproc)
              }

              echo ""
              echo "- Dynamic link: 'make -j$(nproc)'"
              echo "- Dynamic link with i686: 'make CC=i686-unknown-linux-gnu-gcc -j$(nproc)'"
              echo "- Static link: 'make CC=x86_64-unknown-linux-musl-gcc -j$(nproc)'"
              echo "- For kernel compile use 'set-libelf' to enable libelf, 'unset-libelf' to disable it"

              echo "> Gcc"
              gcc --version
              echo "> Nasm"
              nasm -v
              echo ""
              echo "************************************************"
              echo "> C/C++/NASM kernel-space dev environment ready!"
              echo "************************************************"
            '';
          };
        }
      );
    };
}
