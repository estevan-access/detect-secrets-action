# Detect Secrets Action

This github action scans a repository usuing Yelp's [Detect Secrets](https://github.com/Yelp/detect-secrets) library.

## Sample Configuration

This file is accessible at `./.github/workflows/main.yml` in the action's repository.

```
---

# This runs Yelp's 'detect-secrets': https://github.com/Yelp/detect-secrets/blob/master/README.md

name: Scan Code for Secrets

on:
  pull_request:
    types: [opened, reopened, ready_for_review, synchronize]
  push:
    branches:
      - '**'
    tags:
      - '!**'
jobs:
  check-for-secrets:
    runs-on: 'ubuntu-latest'
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Run Yelp's detect-secrets
        uses: estevan-access/detect-secrets-action@v0.2
        env:
          # DS_REQUIRE_BASELINE: 0
          # DS_ADDL_ARGS:
          DS_BASELINE_FILE: .secrets.baseline
          DS_AUDIT_BASELINE: 0
      - name: 'Upload Artifact'
        uses: actions/upload-artifact@v3
        with:
          name: .secrets.baseline
          path: .secrets.baseline
```

## Environment Variables

| Key  | Value Description | Default Value |
| ---- | ----------------- | ------------- |
| `DS_ADDL_ARGS` | Additional arguments to pass to the `detect-secrets` binary | No additional arguments (ie: the empty string) |
| `DS_REQUIRE_BASELINE` | If set to anything other than `0`, we will fail the test if there is no baseline file | `0` creates the baseline as action artifact |
| `DS_AUDIT_BASELINE` | If set to anything other than `0`, we will run the baseline audit (interactive) | `0` no baseline audit 


## Usage Notes

If this action runs and does not see a `detect-secrets` baseline file at `.secrets.baseline` in the root of the repo, then the action will generate that baseline file for you as action artifact.
If you don't commit that file back, then this action is effectively an expensive no-op. 
