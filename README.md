# Nix Templates

Collection of reusable **nix flake templates** for development environments.

## Available Templates

* **java**: Java development (choosable JDK 8/17/21/25 + Maven)
* **java-spring**: Java development with Spring Boot (choosable JDK 8/17/21/25 + Maven + Spring CLI)
* **system**: C/C++/NASM user-space development
* **kernel**: C/C++/NASM kernel-space development (work in progress)

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

Or specify a shell (if available in the template):

```bash
user@host:~$ nix develop .#jdk21
```

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
