# SIMATIC AX specific GitHub Actions and Workflows

In this you'll find some useful GitHub actions, which you can use in your own workflows.

- **setup-apax-runner**: Install apax in the ci pipeline on GitHub
- **apax-build**: Execute the apax build command in the ci pipeline on GitHub
- **test-apax**: Run the AxUnit tests in the ci pipeline on GitHub
- [**apax-publish**](#workflow-apax-publish): Publish a package on the GitHub registry

## Action setup-apax-runner

Install apax in your ci runner on GitHub to youse it in the current job.

**Usage**:

```yml
- name: "Setup the apax in the ci runner"
  uses: simatic-ax/actions/setup-apax-runner
  with:
    APAX_TOKEN: ${{ secrets.APAX_TOKEN }}
```

**Parameter**:

|||
|-|-|
|*APAX_TOKEN*| your token you usually use to login in the AX registry.|
|||

> do not use your token in a readable text. Store it instead in a [GitHub secret](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-encrypted-secrets-for-your-repository-and-organization-for-github-codespaces).

## Action: apax-build

Install the dependencies according the apax.yml in your SIMATIC AX project. And compile the ST code of the src folder in your SIMATIC AX project.

**Usage**:

```yml
- name: "Compile the project (apax build)"
  uses: simatic-ax/actions/apax-build
  with:
    APAX_TOKEN: ${{ secrets.APAX_TOKEN }}
```

> Note: before you can use it, you've to install apax first. That can be done with the action `setup-apax-runner`

**Parameter**:
||||
|-|-|-|
|*APAX_TOKEN*| your token you usually use to login in the AX registry.|required|
|*GITHUB_TOKEN*| your token you usually use to login in the AX registry.|optional
|||


> do not use your token in a readable text. Store it instead in a [GitHub secret](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-encrypted-secrets-for-your-repository-and-organization-for-github-codespaces).

## Action: apax-test

This action executes the AXunit tests.

**Usage**:

```yml
- name: "Test apax artifact"
  uses: ./actions/.github/actions/test-apax-package
```

> Note: before you can use it, you've to install apax first. That can be done with the action `apax-build`

## Example

This example shows an GitHub workflow which demonstrates the usage of actions `setup-apax-runner`, `apax-build` and `apax-test`.

This workflow consists of 4 steps:

1. Checkout your code from the GitRepository
1. Install apax in the ci linux image
1. Install the dependencies and compile the ST code regarding the apax.yml
1. Execute the unit tests.

```yml
jobs:
  build:
    runs-on: ubuntu-24.04

    steps:
      - name: "Checkout code"
        uses: actions/checkout@v3
        with:
          fetch-depth: 1

      - name: "Setup the apax in the ci runner"
        uses: simatic-ax/actions/setup-apax-runner
        with:
          APAX_TOKEN: ${{ secrets.APAX_TOKEN }}

      - name: "Compile the project (apax build)"
        uses: simatic-ax/actions/apax-build
        with:
          APAX_TOKEN: ${{ secrets.APAX_TOKEN }}

      - name: "Test apax artifact"
        uses: ./actions/.github/actions/test-apax-package
```

## Workflow apax-publish

This workflow consists of the following steps:
* Checkout the repository
* Login to the registry
* [optionally call `apax build`]
* Pack and publish the library

### Usage example:

create a `*.yml` file in your `.github/workflows` in your repository with the following content

```yml
on:
  push:
    # Pattern matched against refs/tags
    tags:        
      - '*'

jobs:
  release-apax-lib:
    uses: simatic-ax/actions/.github/workflows/apax-publish.yml@stable
    secrets:
      APAX_TOKEN: ${{ secrets.APAX_TOKEN }}
      DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
      APAX_SIGNKEY: ${{ secrets.APAX_SIGNKEY }}

    with:
      VERSION: ${{ github.ref_name }} # package version which will be created
      RUN_BUILD: false # execute `apax build in the workflow` default true

```

## Additional resources

- [GitHub Workflows](https://docs.github.com/en/actions/using-workflows)
- [GitHub Actions](https://docs.github.com/de/actions)
- [GitHub secrets](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-encrypted-secrets-for-your-repository-and-organization-for-github-codespaces)
  

## Additional tools

**Markdownlint-cli**

This workspace will be checked by the [markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) (there is also documented ho to install the tool) tool in the CI workflow automatically.  
To avoid, that the CI workflow fails because of the markdown linter, you can check all markdown files locally by running the markdownlint with:

```sh
markdownlint **/*.md --fix
```

## Contribution

Thanks for your interest in contributing. Anybody is free to report bugs, unclear documentation, and other problems regarding this repository in the Issues section or, even better, is free to propose any changes to this repository using Merge Requests.

## License and Legal information

Please read the [Legal information](LICENSE.md)
