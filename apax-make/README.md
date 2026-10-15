# Make Source Code Action

## Overview

AX Make is a build system for SIMATIC AX Logic Control Engineering projects. It provides a unified and extensible build pipeline that integrates into the SIMATIC AX Logic Control Engineering development environment, enabling the compilation and testing of projects with a single command.

The **Make Source Code** action runs the `apax make` command, which is the successor of `apax build` and will deprecate it. It executes the build targets (`Build`, `Validate`, `PreBuild`, `Clean`, `Rebuild`) contributed by the AX Make packages installed in your project (e.g. `@ax-as/make`), using the configuration defined in the project's `make.yml` file.

## Inputs

### Optional Parameters

- **apax-make-target**: The ax make target to run. Default is `"Build"`. Available targets:

  | Target | Description |
  | --- | --- |
  | `Build` | Builds the project. Runs `Validate` and `PreBuild` first. Default target. |
  | `Validate` | Runs the validation checks of the installed contributions (e.g. the `make.yml` check). |
  | `PreBuild` | Runs the preparation steps of the installed contributions. |
  | `Clean` | Removes output artifacts from the project. |
  | `Rebuild` | Cleans the project and then builds it again. |

- **apax-make-log-level**: Configure the log level. Allowed values are `none`, `critical`, `error`, `warn`, `info`, `debug`, `trace`. Default is `"Info"`.
- **apax-make-properties**: A newline-delimited string of properties to pass to the `apax make` command, each in the format `KEY:VALUE`. Use `MakeConfigName:<Name>` to select a configuration block defined in `make.yml`.
- **apax-make-project-folder**: Optional path to overwrite the default project folder.
- **path**: The relative path to the project which is utilizing make. Default is `"."`.

## Example Usage

Below is an example of how to use the **Make Source Code** action inside a GitHub workflow:

```yaml
name: Build Project

on:
  push:
    branches:
      - 'main'

jobs:
  build-project:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:4.0.0
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Make Source Code
        uses: simatic-ax/actions/apax-make@v4
        with:
          apax-make-target: "Build"
          apax-make-log-level: "debug"
          apax-make-properties: |
            MakeConfigName:my_plc_compilation
            OutputDirectory:out/release
```

## Failure Scenarios

The action will fail under the following conditions:

1. **Invalid Target**: If the specified target is not contributed by any installed make target package, the action will fail with an error message.
2. **Invalid Properties**: If any of the provided properties are invalid or cause the build to fail, the action will fail with an error message.

Ensure that the target, log level, and properties are correctly specified to avoid these failures.

---
[Back to main page](../README.md)
