{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    base = {
      url = "github:ricdip/nix-templates";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      base,
      fenix,
    }:
    let
      systems = base.systems;
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
            toolchain = fenix.packages.${system}.stable.withComponents [
              "cargo" # downloads your Rust project's dependencies and builds your project (builder)
              "rustc" # safe, concurrent, practical language (compiler)
              "rustfmt" # tool for formatting Rust code according to style guidelines (formatter)
              "clippy" # bunch of lints to catch common mistakes and improve your Rust code (linter)
            ];
          in
          f pkgs toolchain
        );
    in
    {
      devShells = forAllSystems (
        pkgs: toolchain: {
          default = pkgs.mkShell {
            packages = with pkgs; [
              toolchain # configured Rust toolchain
              # rust-analyzer # language server

              openssl # cryptographic library that implements the SSL and TLS protocols
              # pkg-config # tool that allows packages to find out information about other packages

              # utils
              license-generator # CLI tool for generating license files
              grex # a CLI tool for generating regular expressions from user-provided test cases
              bitwise # terminal based bitwise calculator
              just # a handy way to save and run project-specific commands
              onefetch # CLI git information tool
              scc # a very fast accurate code counter with complexity calculations
            ];

            shellHook = ''
              export RUST_BACKTRACE=1

              echo ""
              echo "> Rustc"
              rustc -vV
              echo "> Cargo"
              cargo version
              echo ""
              echo "*****************************"
              echo "> Rust dev environment ready!"
              echo "*****************************"
            '';
          };
        }
      );
    };
}
