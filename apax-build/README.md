# Build Source Code Action

## Overview

The **Build Source Code** action builds the source code based on the project's `apax.yaml` file. This action is useful for automating the build process in your CI/CD pipelines.

## Prerequisites

`apax build` is a **contributed command**, i.e. it is provided by an apax package (typically `@ax/sdk` and related packages) rather than by apax core. This action therefore requires:

- `apax install` has already been executed in the project (e.g. via the `apax-install` action) so that the packages contributing the `build` command are available.
- The project's `apax.yml` declares the dependencies that provide the `build` command.

## Inputs

### Optional Parameters

- **apax-build-args**: A newline-delimited string of arguments to pass to the `apax build` command. The default will be taken from the `apax.yml`.
- **apax-build-targets**: A newline-delimited string of targets to pass to the `apax build` command. The default will be taken from the `apax.yml`.
- **predefined-preprocessor-symbols**: A newline-delimited string of preprocessor symbols to define. The symbols are passed to the `apax build` command. The default will be taken from the `apax.yml`.
- **verbose**: If `true`, adds `--verbose` to the command for more detailed build output. Default: `false`. Note: `apax build` is a contributed command and does not support the apax core `--log` option.

## Example Usage

Below is an example of how to use the **Build Source Code** action inside a GitHub workflow:

```yaml
name: Build Project

on:
  push:
    branches:
      - 'main'

jobs:
  build-project:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:4.3.0
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Build Source Code
        uses: simatic-ax/actions/apax-build@v4
        with:
          apax-build-args: |
            --debug
          apax-build-targets: |
            llvm
            1500
          predefined-preprocessor-symbols: |
            SYMBOL1
            SYMBOL2
          verbose: "true"
```

## Failure Scenarios

The action will fail under the following conditions:

2. **Invalid Build Arguments**: If any of the provided build arguments, targets, or preprocessor symbols are invalid or cause the build to fail, the action will fail with an error message.

Ensure that the build arguments, targets, and preprocessor symbols are correctly specified to avoid these failures.

---
[Back to main page](../README.md)