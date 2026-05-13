{
  description = "LaTex environment";

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
            # texliveBasic # TeX Live environment
            # texliveSmall # TeX Live environment
            texliveMedium # TeX Live environment
            # texliveFull # TeX Live environment
            texlivePackages.moderncv # a modern curriculum vitae class
            # utils
            just # a handy way to save and run project-specific commands
          ];

          shellHook = ''
            echo ""
            echo "> LaTex"
            pdflatex --version
            echo ""
            echo "**************************"
            echo "> LaTex environment ready!"
            echo "**************************"
            export PS1="$PS1 (latex): "
          '';
        };
      });
    };
}
