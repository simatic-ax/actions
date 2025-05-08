# Test Source Code Action

## Overview

The **Test Source Code** action tests the source code based on the project's `apax.yaml` file. This action is useful for automating the testing process in your CI/CD pipelines.

## Inputs

### Optional Parameters

- **ingore-scripts**: Do not run pretest and posttest scripts. Default is `"false"`.
- **playlist**: Specifies the playlist filepath. Default is `""`.
- **coverage**: Specifies to get coverage. Default is `"false"`.
- **loglevel**: Specifies log level. Options are `info` (default) and `debug`. Default is `"info"`.
- **path**: The relative path to the project which is to be tested. Default is `"."`.

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
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:3.5.0
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Test Source Code
        uses: simatic-ax/actions/apax-test 
        with:
          ingore-scripts: "true"
          playlist: "path/to/playlist"
          coverage: "true"
          loglevel: "debug"
```

## Failure Scenarios

The action will fail under the following conditions:

1. **Invalid Playlist Path**: If the specified playlist path does not exist, the action will fail with an error message.
2. **Invalid Log Level**: If the specified log level is not `info` or `debug`, the action will fail with an error message.


Ensure that the `playlist` path exists and the `loglevel` is correctly specified to avoid these failures.

---
[Back to main page](../README.md)