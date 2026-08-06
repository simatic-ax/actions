# Test Source Code Action

## Overview

The **Test Source Code** action tests the source code based on the project's `apax.yaml` file. This action is useful for automating the testing process in your CI/CD pipelines.

## Prerequisites

`apax test` is a **contributed command**, i.e. it is provided by an apax package (typically `@ax/axunit`) rather than by apax core. This action therefore requires:

- `apax install` has already been executed in the project (e.g. via the `apax-install` action) so that the packages contributing the `test` command are available.
- The project's `apax.yml` declares the dependencies that provide the `test` command.

## Inputs

### Optional Parameters

- **ignore-scripts**: Do not run pretest and posttest scripts. Default is `"false"`.
- **playlist**: Specifies the playlist filepath. Default is `""`.
- **coverage**: Specifies to get coverage. Default is `"false"`.
- **log-level**: Log level for the `apax test` command. Allowed values: `info`, `debug`. Default is empty (test-command default: `info`). Mapped to `--loglevel`. Note: `apax test` is a contributed command (from `@ax/axunit`) and does **not** support the `trace` level that apax core commands accept.
- **path**: The relative path to the project which is to be tested. Default is `"."`.

### Deprecated Parameters

- **ingore-scripts**: Deprecated (typo). Use `ignore-scripts` instead.
- **loglevel**: Deprecated. Use `log-level` instead.

### Not Yet Supported Parameters

- **filter**: Specifies the filter for the test cases.
- **engine**: Engine for running test(s) -> llvm, mc7p or plcsim.
- **target-ip**: Target IP address for the PLC. Required when target is `mc7p` or `plcsim`.
- **username**: The legitimation user name to get access to the PLC. Required when target is `mc7p` or `plcsim` and a UMAC-PLC.
- **password**: The certificate file to get access to the PLC. Required when target is `mc7p` or `plcsim` and a PLC which requires a certificate.
- **certificate**: The certificate file to get access to the PLC. Required when target is `mc7p` or `plcsim` and a PLC which requires a certificate.

## Example Usage

Below is an example of how to use the **Test Source Code** action inside a GitHub workflow:

```yaml
name: Test Project

on:
  push:
    branches:
      - 'main'

jobs:
  test-project:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:4.3.0
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Test Source Code
        uses: simatic-ax/actions/apax-test 
        with:
          ignore-scripts: "true"
          playlist: "path/to/playlist"
          coverage: "true"
          log-level: "debug"
```

## Failure Scenarios

The action will fail under the following conditions:

1. **Invalid Playlist Path**: If the specified playlist path does not exist, the action will fail with an error message.
2. **Invalid Log Level**: If the specified log level is not one of `info`, `debug`, the action will fail with an error message. `trace` is explicitly rejected because `apax test` does not support it.
3. **Mutually Exclusive Inputs**: If both `log-level` and the deprecated `loglevel` (or both `ignore-scripts` and the deprecated `ingore-scripts`) are set, the action will fail.


Ensure that the `playlist` path exists and the `log-level` is correctly specified to avoid these failures.

---
[Back to main page](../README.md)