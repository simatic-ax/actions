### Update Apax Action

## Overview

The **Update Apax** action updates the Apax tool itself. Use this action with caution, as new major versions of Apax aren't guaranteed to work with every CI image.

## Inputs

### Optional Parameters

- **version**: The version of Apax to update to. If not specified, the latest version within the current major version will be installed.
- **check**: Check whether an update is available, but do not install it. Default is `"false"`.
- **force-latest**: Force update to the latest version. Be aware that this could be a major version update which might include breaking changes. Default is `"false"`.

## Example Usage

Below is an example of how to use the **Update Apax** action inside a GitHub workflow:

```yaml
name: Update Apax

on:
  push:
    branches:
      - 'main'

jobs:
  update-apax:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:3.4.2
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Update Apax
        uses: simatic-ax/actions/apax-self-update@v3
        with:
          check: "true"
          force-latest: "false"
          version: "3.4.2"
```

## Failure Scenarios

The action will fail under the following conditions:

1. **Invalid Version Format**: If the provided `version` does not comply with semantic versioning, the action will fail with an error message.

Ensure that the `version` parameter follows the semantic versioning format to avoid these failures.

---
[Back to main page](../README.md)