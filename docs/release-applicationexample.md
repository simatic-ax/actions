
# Release an application example

## Use the release workflow

Insert a workflow file like `release-applicationexample.yml` in the folder `.github\workflows`

The file should have the following content:

```yml
on:
  push:
    # Pattern matched against refs/tags
    tags:
      - "*"

jobs:
  release-apax-lib:
    uses: simatic-ax/actions/.github/workflows/apax-publish-applicationexample.yml@stable
    secrets:
      APAX_TOKEN: ${{ secrets.APAX_TOKEN }}
      DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}

    with:
      VERSION: ${{ github.ref_name }}
      PROJECT_NAME: ae-tiax
```

