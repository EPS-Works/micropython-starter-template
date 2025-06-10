# Micropython Project Template

A template for projects using the Ardusimple SDK, a custom MicroPython firmware distribution with pre-installed utilities and hardware abstractions. The goal is to enhance developer experience (DX) and application development by integrating modern tooling like type hints, linter, formatter, testing and production build pipeline.

This template already contains stubs for extra modules shipped with the Ardusimple's firmware, as `utoml` and `sdk`.

## Get Started

Start a new project using this template. Fill up the `pyproject.toml` file with the information of your project.

Create and activate a virtual environment and setup the project

```bash
python -m venv .venv
source .venv/bin/activate

make setup
```

Make sure to have [Black Formatter active](https://dev.to/adamlombard/how-to-use-the-black-python-code-formatter-in-vscode-3lo0) in your IDE.

## Tests

Run tests with optional `-s` (do not capture stdout) and `-v` (verbose) flags.

```bash
# Activate virtual environment
source .venv/bin/activate

pytest -s -v
```

## Build

Your application can be compiled into `.mpy` files for better performance and memory usage when deployed on MicroPython devices.

Be sure you have [mpy-cross](https://pypi.org/project/mpy-cross/) and Make installed.

```bash
make build
make rebuild # Build a clean new version
make clean-build  # Optional. Remove build directory
```
