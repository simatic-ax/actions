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

### [apax-self-update](apax-self-update/action.yml)
Updates the Apax tool itself. Use this action with caution, as new major versions of Apax aren't guaranteed to work with every CI image.

Further details and information can be found in the [documentation](apax-self-update/README.md).

## Usage

Each action can be used within your GitHub workflows to automate specific tasks. Refer to the individual action's documentation for detailed usage instructions and examples.

### Example Workflow

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    # Mandatory, cause the referenced image contains an apax installation
    container:
      image: ghcr.io/simatic-ax/ci-images/apax-ci-image:3.4.2
    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Build project
      uses: simatic-ax/actions/apax-build@v3

    - name: Test project
      uses: simatic-ax/actions/apax-test@v3
```

## Workflows

This repository also includes predefined workflows for development and release processes.

### Development Workflow

The development workflow (`package-development-workflow.yml`) is triggered on pushes and pull requests to the `main` branch. It builds and tests the source code.

Further details and information can be found in the [documentation](./docs/development-workflow.md).

### Release Workflow

The release workflow (`package-release-workflow.yml`) is triggered when a release is published via the GitHub UI. It first calls the development workflow and then proceeds to version, package, and publish the source code.

Further details and information can be found in the [documentation](./docs/release-workflow.md).

### Templatify Workflow

The templatify workflow (`templatify-workflow.yml`) is triggered manually. This workflow aims to take the repository, create an apax compliant template package out of it and publish it to the GitHub Container registry.

## Versioning

The versioning of the actions follows two main concepts:

1. stable versions are to be referenced following the basic [SemVer](https://semver.org/) pattern, where a concrete version is used, e.g. @3.4.2
2. rolling-forward major versions are to be referenced using only the major version, e.g. @v3

Depending on your requirements, you may either pick a stable version, which is guaranteed to not change, or the rolling-forward major version, in case you'd like to benefit from smaller updates w/o having to change your workflow.

## Disclaimer

All usages of actions-test are solely for the purpose of demonstration and testing the actions itself. You shall remove them in case you'd like to copy any of the examples in this repository.

Furthermore you need to take care of altering the uses-statements of the workflows steps to simatic-ax/actions/apax-<command-name>@vX.