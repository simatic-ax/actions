# Apax Login Action

## Overview

The **Apax Login** action performs a login to the SIMATIC AX registry and optionally to additional registries. This action is useful for automating authentication processes in your CI/CD pipelines.

## Inputs

### Mandatory Parameters

- **apax-token**: The token to authenticate with the SIMATIC AX registry.

### Optional Parameters

- **registries**: A newline-delimited string of registries with URL and token (format: `url1,token1\nurl2,token2...`). Default is an empty string.

## Example Usage

Below is an example of how to use the **Apax Login** action inside a GitHub workflow:

```yaml
name: Authenticate Registries

on:
  push:
    branches:
      - 'main'

jobs:
  authenticate:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:3.5.0
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Apax Login
        uses: simatic-ax/actions/apax-login@v3
        with:
          apax-token: ${{ secrets.APAX_TOKEN }}
          registries: |
            https://registry1.example.com,token1
            https://registry2.example.com,token2
```
## Failure Scenarios

The action will fail under the following conditions:

1. **Invalid URL Format**: If any provided URL in the `registries` input does not match the expected URL format, the action will fail with an error message.
2. **Incomplete Registry Entry**: If any registry entry in the `registries` input is incomplete (missing URL or token), the action will fail with an error message.
3. **Invalid Token**: If the provided `apax-token` is empty, the action will fail.

Ensure that the `apax-token` is valid and that the `registries` input follows the correct format to avoid these failures.

---
[Back to main page](../README.md)