# Apax Doctor Action

## Overview

The **Apax Doctor** action runs `apax doctor` to perform diagnostic checks on the current apax setup. It can be used as a preflight step in a CI workflow to detect authentication problems, registry connectivity issues, environment misconfigurations or inconsistent project state before other apax commands are executed.

Available since apax 4.2.

## Inputs

### Optional Parameters

- **check**: The diagnostic check to run. Allowed values: `auth`, `registry`, `env`, `git`, `node`, `project`, `all`. Default is `"all"`.
- **format**: Output format. Allowed value: `json`. If empty, the default human-readable text output is used. Default is `""`.
- **verbose**: Show detailed diagnostic information including suggestions for resolving issues. Default is `"false"`.
- **fail-on-warning**: If set to `"true"`, the step will fail when apax doctor reports warnings (exit code 2). Otherwise warnings do not fail the step. Default is `"false"`.
- **log-level**: Log level for the apax command. Allowed values: `trace`, `debug`, `info`. Default is empty (apax default: `info`).
- **path**: The relative path to the project to run the diagnostic checks against. Default is `"."`.

## Exit Code Handling

`apax doctor` returns:

- `0`: all checks passed
- `2`: warnings present (no failures)
- `1`: one or more checks failed

The action always fails the step on exit code `1`. Exit code `2` (warnings) fails the step only when `fail-on-warning` is set to `"true"`.

## Example Usage

Below is an example of how to use the **Apax Doctor** action as a preflight step in a GitHub workflow:

```yaml
name: Build with Preflight

on:
  push:
    branches:
      - 'main'

jobs:
  build:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:4.3.0
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Login
        uses: simatic-ax/actions/apax-login@v4
        with:
          apax-token: ${{ secrets.APAX_TOKEN }}

      - name: Preflight check
        uses: simatic-ax/actions/apax-doctor@v4
        with:
          check: auth
          fail-on-warning: "true"

      - name: Install dependencies
        uses: simatic-ax/actions/apax-install@v4
        with:
          immutable: "true"
```

## Failure Scenarios

The action will fail under the following conditions:

1. **Invalid `check` value**: If `check` is not one of `auth`, `registry`, `env`, `git`, `node`, `project`, `all`, the action will fail with an error message.
2. **Invalid `format` value**: If `format` is not empty and not `json`, the action will fail with an error message.
3. **Doctor failures**: If `apax doctor` reports failures (exit code `1`), the action will fail.
4. **Doctor warnings with fail-on-warning enabled**: If `apax doctor` reports warnings (exit code `2`) and `fail-on-warning` is `"true"`, the action will fail.

---
[Back to main page](../README.md)
