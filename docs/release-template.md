
# Release a template

## Use the release workflow

Insert a workflow file like `release-template.yml` in thr folder `.github\workflows`

The file should have the following content:

```yml
on:
  push:
    # Pattern matched against refs/tags
    tags:
      - "*"

jobs:
  release-apax-lib:
    uses: simatic-ax/actions/.github/workflows/apax-publish-template.yml@stable
    secrets:
      APAX_TOKEN: ${{ secrets.APAX_TOKEN }}
      DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}

    with:
      VERSION: ${{ github.ref_name }}
```

