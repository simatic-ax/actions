# Templatify Repository Action

## Overview

The **Templatify Repository** action creates a template based on the project. This template can later be used as a template during an `apax create`, e.g., `apax create @simatic-ax/template-my-project new-project-name`.

## Inputs

### Mandatory Parameters

- **version**: The version to set in the `apax.yml` file.

### Optional Parameters

- **path**: The relative path to the folder of the project which is to be templatified. Default is `"."`.

## Example Usage

Below is an example of how to use the **Templatify Repository** action inside a GitHub workflow:

```yaml
name: Templatify Project

on:
  push:
    branches:
      - 'main'

jobs:
  templatify-project:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:3.4.2
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Templatify Repository
        uses: simatic-ax/actions/apax-templatify@v3
        with:
          version: "0.0.1"
```

## Failure Scenarios

The action will fail under the following conditions:

1. **Missing `apax.yml` File**: If the `apax.yml` file is not found in the specified path, the action will fail with an error message.
2. **Missing `templatify-meta-information.yml` File**: If the `templatify-meta-information.yml` is not present, the action will fail with an error message.
3. **Failed to Install `dos2unix`**: If the `dos2unix` tool fails to install, the action will fail with an error message.

Ensure to provide the `templatify-meta-information.yml`inside your project to avoid these failures.