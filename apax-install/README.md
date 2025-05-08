# Install Dependencies Action

## Overview

The **Install Dependencies** action installs the dependencies and devDependencies based on the project's `apax.yaml` file. This action is useful for setting up your project's environment by ensuring all necessary packages are installed.

## Inputs

### Optional Parameters

- **immutable**: Install all dependencies and devDependencies from the `apax-lock.json` or throw an error if not present or not in sync with your `apax.yml`. Default is `"false"`.
- **redownload**: Install all dependencies and devDependencies from your `apax.yml` but force a redownload of the packages to the global cache. Default is `"false"`.
- **copy-local**: Install all dependencies and devDependencies from your `apax.yml` and copy them into your project instead of linking to the global cache (be aware that this increases the memory needs of your project). Default is `"false"`.
- **verbose**: Install all dependencies and devDependencies from your `apax.yml`, showing additional output. Default is `"false"`.
- **catalog**: Installs dependencies according to the catalog. Default is `"false"`.
- **strict**: Applies the exact package versions from the catalog. Default is `"false"`.
- **path**: The relative path to the project whose dependencies are to be installed. Default is `"."`.

### Not Yet Supported Parameters

- **installStrategy**: Currently not supported.

## Example Usage

Below is an example of how to use the **Install Dependencies** action inside a GitHub workflow:

```yaml
name: Install Dependencies

on:
  push:
    branches:
      - 'main'

jobs:
  install-dependencies:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:3.5.0
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Install Dependencies
        uses: simatic-ax/actions/apax-install@v3
        with:
          immutable: "true"
          redownload: "false"
          copy-local: "false"
          verbose: "true"
          catalog: "false"
          strict: "false"
```
## Failure Scenarios

The action will fail under the following conditions:

1. **Invalid `strict` Flag Usage**: If the `strict` flag is set to `true` without the `catalog` flag, the action will fail with an error message.

Ensure that the `strict` flag is used in conjunction with the `catalog` to avoid these failures.

---
[Back to main page](../README.md)