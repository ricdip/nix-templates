# Show help message
default:
    @just --list

# Format nix files
format:
    fd -e nix -X nixfmt {}
