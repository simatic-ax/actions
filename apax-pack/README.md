# Create Apax Package Action

## Overview

The **Create Apax Package** action creates an Apax package based on the project's `apax.yaml` file. This action is useful for packaging your project for distribution.

## Inputs

### Mandatory Parameters

- **key**: Pack with a specific private key.

### Optional Parameters

- **ignore-scripts**: Pack without executing prepack and postpack scripts. Default is `"false"`.
- **path**: The relative path to the project which is to be packed. Default is `"."`.

## Example Usage

Below is an example of how to use the **Create Apax Package** action inside a GitHub workflow:

```yaml
name: Create Package

on:
  push:
    branches:
      - 'main'

jobs:
  create-package:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:4.0.0
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Create Apax Package
        uses: ./apax-pack # replace with the correct path or repository
        with:
          key: ${{ secrets.APAX_SIGNKEY }}
          ignore-scripts: "false"
```
---
[Back to main page](../README.md)