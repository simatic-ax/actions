# Development Workflow Documentation

The development workflow (`package-development-workflow.yml`) is designed to automate the build and test processes during the development phase of the project. This workflow is triggered on the following events:

- Pushes to the `main` branch or any of its sub-branches.
- Pull requests targeting the `main` branch or any of its sub-branches.
- Workflow calls with a specified reference.

## Key Steps

1. **Checkout Code**: Checks out the repository code based on the specified reference.
2. **Login to Required Registries**: Logs into the necessary registries using provided tokens.
3. **Install Dependencies**: Installs the project's dependencies as defined in the `apax.yaml` file.
4. **Build Source Code**: Builds the source code with specified targets and arguments.
5. **Test Source Code**: Runs tests on the source code with coverage and debug logging enabled.
6. **Upload Build Artifacts**: Uploads the build artifacts for later use.

## Workflow Triggers

The workflow is triggered on the following events:
- Pushes to the `main` branch or any of its sub-branches.
- Pull requests targeting the `main` branch or any of its sub-branches.
- Workflow calls with a specified reference.

## Secrets

The workflow requires the following secrets:
- `APAX_TOKEN`: Token to authenticate with the SIMATIC AX registry.
- `DEPLOY_TOKEN`: Token to authenticate with the GitHub Container registry.

## Inputs

The workflow accepts the following inputs:
- `ref`: The reference to the branch or commit to checkout.

## Specialties

- **Containerized Environment**: The workflow runs in a containerized environment using the `ghcr.io/simatic-ax/ci-images/apax-ci-image:3.4.2` image.
- **Custom Actions**: The workflow uses custom actions (apax-login, apax-install, apax-build, apax-test) that are specific to the SIMATIC AX project.
- **Artifact Retention**: The build artifacts are uploaded and retained for 90 days.