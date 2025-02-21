# Build Source Code Action

## Overview

The **Build Source Code** action builds the source code based on the project's `apax.yaml` file. This action is useful for automating the build process in your CI/CD pipelines.

## Inputs

### Optional Parameters

- **apax-build-args**: A newline-delimited string of arguments to pass to the `apax build` command. The default will be taken from the `apax.yml`.
- **apax-build-targets**: A newline-delimited string of targets to pass to the `apax build` command. The default will be taken from the `apax.yml`.
- **predefined-preprocessor-symbols**: A newline-delimited string of preprocessor symbols to define. The symbols are passed to the `apax build` command. The default will be taken from the `apax.yml`.

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
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:3.4.2
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Build Source Code
        uses: simatic-ax/actions/apax-build@v3
        with:
          apax-build-args: |
            --arg1
            --arg2
          apax-build-targets: |
            target1
            target2
          predefined-preprocessor-symbols: |
            SYMBOL1
            SYMBOL2
```

## Failure Scenarios

The action will fail under the following conditions:

2. **Invalid Build Arguments**: If any of the provided build arguments, targets, or preprocessor symbols are invalid or cause the build to fail, the action will fail with an error message.

Ensure that the build arguments, targets, and preprocessor symbols are correctly specified to avoid these failures.