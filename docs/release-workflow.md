# Release Workflow Documentation

The release workflow (`package-release-workflow.yml`) is designed to automate the release process when a new release is published via the UI. This workflow ensures that the package is built, versioned, and published correctly.

## Key Steps

1. **Execute Development Workflow**: Calls the development workflow to build and test the source code.
2. **Checkout Code**: Checks out the repository code based on the release reference.
3. **Download Build Artifacts**: Downloads the build artifacts generated during the development workflow.
4. **Version Package**: Versions the package based on the release tag name.
5. **Package Source Code**: Packages the source code for release.
6. **Login to Required Registries**: Logs into the necessary registries using provided tokens.
7. **Publish Apax Package**: Publishes the package to the specified registries.

## Workflow Triggers

The workflow is triggered when a release is published via the UI.

## Secrets

The workflow requires the following secrets:
- `APAX_TOKEN`: Token to authenticate with the SIMATIC AX registry.
- `DEPLOY_TOKEN`: Token to authenticate with additional registries.
- `APAX_SIGNKEY`: Key to sign the package.

## Specialties

- **Conditional Execution**: The workflow only runs if the release is a tag and the `target_commitish` is a release branch.
- **Containerized Environment**: The workflow runs in a containerized environment using the `ghcr.io/simatic-ax/ci-images/apax-ci-image:3.4.2` image.
- **Custom Actions**: The workflow uses custom actions (apax-version, apax-pack, apax-login, apax-publish) that are specific to the SIMATIC AX project.