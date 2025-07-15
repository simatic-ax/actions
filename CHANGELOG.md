# Changelog

## [4.0.0] - Unreleased

### Changed
- Removed the keyVersion parameter from the apax-pack action

## [3.4.2] - 2025-03-01

### Added
- Introduces GitHub actions to build a complete CI/ CD workflow

### Changed
- Adds debug output of the event of the development workflow
- The workflows now make use of dedicated permissions. 
- The automatic changelog update has been changed.
- The update of the changelog including the PR creation is now done inside a script
- The update of the changelog including the PR creation is now done inside a script
- Re-tagging during release only happens for the major version tag

### Fixed
- Fixes the handling of secrets inside the GitHub workflows
- Fixes a malformed condition to allow uploading of artifacts during a workflow call
- Uploading artifacts now happens only in case of a release being run
- Fixes a path issue that caused a script run to fail
- Extends the permissions of the development workflow
- Marks the workspace directory of the CI pipeline as safe for git operations
- Alters the used workspace variable inside the release workflow
- Deactivate automatic changelog generation
- Fixes the re-tagging step during the release workflow