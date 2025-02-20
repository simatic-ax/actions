# SIMATIC AX Actions

This repository contains a collection of GitHub Actions for automating various tasks related to SIMATIC AX projects. These actions are designed to streamline the development, testing, packaging, and deployment processes.

## Actions

Below is a list of the individual actions available in this repository:

### [apax-build](apax-build/action.yml)
Builds the source code based on the project's `apax.yaml` file.

Further details and information can be found in the [documentation](apax-build/README.md).

### [apax-install](apax-install/action.yml)
Installs the dependencies and devDependencies based on the project's `apax.yaml` file.

Further details and information can be found in the [documentation](apax-install/README.md).

### [apax-login](apax-login/action.yml)
Performs a login to the SIMATIC AX registry and optionally to additional registries.

Further details and information can be found in the [documentation](apax-login/README.md).

### [apax-pack](apax-pack/action.yml)
Creates an Apax package based on the project's `apax.yaml` file.

Further details and information can be found in the [documentation](apax-pack/README.md).

### [apax-publish](apax-publish/action.yml)
Publishes an Apax package to one or multiple remote registries.

Further details and information can be found in the [documentation](apax-publish/README.md).

### [apax-templatify](apax-templatify/action.yml)
Creates a template based on the project. This template can later be used as a template during an `apax create`.

Further details and information can be found in the [documentation](apax-templatify/README.md).

### [apax-test](apax-test/action.yml)
Tests the source code based on the project's `apax.yaml` file.

Further details and information can be found in the [documentation](apax-test/README.md).

### [apax-version](apax-version/action.yml)
Sets the version property of the `apax.yaml` file to the provided version.

Further details and information can be found in the [documentation](apax-version/README.md).

## Usage

Each action can be used within your GitHub workflows to automate specific tasks. Refer to the individual action's documentation for detailed usage instructions and examples.

### Example Workflow

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Build project
      uses: simatic-ax/actions/apax-build@v1

    - name: Test project
      uses: simatic-ax/actions/apax-test@v1
```

## Workflows

This repository also includes predefined workflows for development and release processes.

### Development Workflow

The development workflow (`package-development-workflow.yml`) is triggered on pushes and pull requests to the `main` branch. It builds and tests the source code.

### Release Workflow

The release workflow (`package-release-workflow.yml`) is triggered when a release is published via the GitHub UI. It first calls the development workflow and then proceeds to version, package, and publish the source code.