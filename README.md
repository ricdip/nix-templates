# Nix Templates

Collection of reusable **nix flake templates** for creating development environments.

## Available Templates

* **java**: Java development environment (choosable JDK 8/17/21/25 + Maven)
* **java-spring**: Java development environment with Spring Boot (choosable JDK 8/17/21/25 + Maven + Spring CLI)
* **system**: C/C++/NASM user-space development environment
* **kernel**: C/C++/NASM kernel-space development environment
* **python-poetry**: Python development environment with poetry
* **go**: Go development environment
* **rust**: Rust development environment
* **zig**: Zig development environment
* **nodejs**: NodeJS development environment
* **latex**: LaTex environment

## Usage

Initialize a new project using a template:

```bash
user@host:~$ nix flake init -t github:ricdip/nix-templates#java
```

Replace `java` with one of the available templates.

Then enter the development environment:

```bash
user@host:~$ nix develop
```

Or specify a shell (if available in the nix template):

```bash
user@host:~$ nix develop .#jdk21
```

Or create the workspace by using the `justfile` recipe `create-workspace`:

```bash
# command that creates the `devshell` directory and moves the flake.nix inside that directory
user@host:~$ just create-workspace
```

After creating the workspace, it can be entered with the recipe `enter-workspace` or `enter-workspace-with-version`:

```bash
# use the default shell
user@host:~$ just enter-workspace

# specify a shell (if available in the nix template)
user@host:~$ just enter-workspace-with-version jdk21
```

The workspace creation can be useful to limit the size of the directory copied to the nix store. `create-workspace` copies only the `devshell` directory to the nix store instead of the current project directory.

## Discover Templates

```bash
user@host:~$ nix flake show github:ricdip/nix-templates
```

## Supported Systems

This flake is supported on:

- `x86_64-linux`
- `aarch64-linux`

## Notes

* Always specify the template using `#<name>`
* Each template creates a ready-to-use development shell
* Use with `nix develop` (or `direnv` for automatic loading)
* All templates share the same pinned `nixpkgs` for consistency
