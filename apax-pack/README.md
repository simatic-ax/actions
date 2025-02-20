# Create Apax Package Action

## Overview

The **Create Apax Package** action creates an Apax package based on the project's `apax.yaml` file. This action is useful for packaging your project for distribution.

## Inputs

### Mandatory Parameters

- **key**: Pack with a specific private key.

### Optional Parameters

- **key-version-v2**: Pack with a specific private key but in version v2. Default is `"false"`.
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
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Create Apax Package
        uses: ./apax-pack # replace with the correct path or repository
        with:
          key: ${{ secrets.APAX_SIGNKEY }}
          key-version-v2: "true"
          ignore-scripts: "false"
```

## Failure Scenarios

The action will fail under the following conditions:

1. **Missing Key**: If the `key` parameter is not provided, the action will fail with an error message.
2. **Invalid Key Version Usage**: If the `key-version-v2` flag is set to `true` without the `key` parameter, the action will fail with an error message.

Ensure that the `key` parameter is provided, the `key-version-v2` flag is used correctly to avoid these failures.