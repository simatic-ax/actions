# Publish Apax Package Action

## Overview

The **Publish Apax Package** action publishes an Apax package to one or multiple remote registries. This action is useful for automating the deployment of your Apax packages.

## Inputs

### Mandatory Parameters

- **registries**: A newline-delimited string of URLs of registries the package is to be published to.

### Optional Parameters

- **tag**: The tag to apply to the published package. Default is `"latest"`.
- **path**: The relative path to the folder where the Apax package is located. Default is `"."`.

## Example Usage

Below is an example of how to use the **Publish Apax Package** action inside a GitHub workflow:

```yaml
name: Publish Package

on:
  push:
    branches:
      - 'main'

jobs:
  publish-package:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Publish Apax Package
        uses: simatic-ax/actions/apax-publish 
        with:
          registries: |
            https://registry1.example.com
            https://registry2.example.com
          tag: "latest"
```
## Failure Scenarios

The action will fail under the following conditions:

1. **No Package Found**: If no `.apax.tgz` package is found in the specified path, the action will fail with an error message.
2. **Multiple Packages Found**: If multiple `.apax.tgz` packages are found in the specified path, the action will fail with an error message.
3. **Invalid URL Format**: If any provided URL in the `registries` input does not match the expected URL format, the action will fail with an error message.

Ensure that the `registries` input follows the correct format and that the `path` parameter points to a valid directory containing a single `.apax.tgz` package to avoid these failures.