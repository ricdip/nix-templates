# Nix Templates

Collection of reusable **nix flake templates** for development environments.

## Available Templates

* **java**: Java development (choosable JDK 8/17/21/25 + Maven)
* **systems**: C/C++/NASM development (low-level programming)

## Usage

Initialize a new project using a template:

```bash
user@host:~$ nix flake init -t github:ricdip/nix-templates#java
```

Replace `java` with one of the available templates.

## Discover Templates

```bash
user@host:~$ nix flake show github:ricdip/nix-templates
```

## Notes

* Always specify the template using `#<name>`
* Each template creates a ready-to-use development shell
* Use with `nix develop` (or `direnv` for automatic loading)

