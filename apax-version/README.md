# Set Version Action

## Overview

The **Set Version** action sets the version property of the `apax.yml` file to the provided version. This action is useful for automating version updates in your project.

## Inputs

### Mandatory Parameters

- **version**: The version to set in the `apax.yml` file. This parameter must be compliant with semantic versioning.

### Optional Parameters

- **path**: The relative path to the project which is to be versioned. Default is `"."`. Meaning the current directory wherein the action is being executed

## Example Usage

Below is an example of how to use the **Set Version** action inside a GitHub workflow:

```yaml
name: Update Version

on:
  push:
    branches:
      - 'main'

jobs:
  set-version:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:3.4.2
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set Version
        uses: simatic-ax/ations/apax-version@v3
        with:
          version: "1.2.3"
```
## Failure Scenarios

The action will fail under the following conditions:

1. **Invalid Version Format**: If the provided `version` does not comply with semantic versioning, the action will fail with an error message.

Ensure that the `version` parameter follows the semantic versioning format to avoid these failures.