# Collect Logs Action

## Overview

The **Collect Logs Action** is designed to gather diagnostic log files from a specified source directory and copy them to a designated destination directory within your GitHub Actions workflow. This is particularly useful for collecting error logs or other diagnostic information when a workflow step fails, making debugging easier.

## Inputs

### Mandatory Parameters

-   **`log_source_dir`**:
    -   **Description**: The absolute path to the directory where log files are searched.
    -   **Example**: `/github/home/.apax/logs/`

-   **`log_dest_dir`**:
    -   **Description**: The absolute path to the directory where the collected log files should be temporarily stored. If this directory does not exist, it will be created. This directory is typically used to prepare files for subsequent steps, such as uploading them as an artifact.
    -   **Example**: `/github/workspace/apax-logs/`

## Example Usage

Below is an example of how to integrate the **Collect Logs Action** into a GitHub workflow, typically after a step that might fail, to ensure diagnostic logs are captured.

```yaml
name: My Workflow with Log Collection

on: [push]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Run potentially failing step
        # Replace this with your actual step that might produce logs
        run: |
          echo "Simulating a failing step..."
          mkdir -p /tmp/my-app/logs/
          echo "Error: Something went wrong!" > /tmp/my-app/logs/error.log
          echo "Warning: Disk space low." > /tmp/my-app/logs/warning.log
          exit 1 # Force failure for demonstration

      - name: Collect Diagnostic Logs on Failure
        if: failure() # This ensures the log collection only runs if a previous step failed
        uses: your-org/your-repo/collect-logs@v1 # Replace with the actual path to your action
        with:
          log_source_dir: /tmp/my-app/logs/ # Example source directory
          log_dest_dir: /github/workspace/collected-app-logs/ # Example destination directory

      - name: Upload Collected Logs as Artifact
        if: always() # Use always() to upload logs even if the collection step had issues
        uses: actions/upload-artifact@v4
        with:
          name: diagnostic-app-logs
          path: /github/workspace/collected-app-logs/ # Path must match log_dest_dir
          # retention-days: 5 # Optional: how long to keep the artifact
```

### Failure Scenarios
The action will provide informative messages in the workflow output under the following conditions:

1. Source Directory Does Not Exist: If the log_source_dir specified does not exist, a message will indicate that no logs can be copied.
2. No Log Files Found: If the log_source_dir exists but contains no files, a message will indicate that no log files were found to copy.

---
[Back to main page](../README.md)