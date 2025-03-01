# Changelog
## [3.4.2] - 2025-03-01

### Added
- Introduces GitHub actions to build a complete CI/ CD workflow by in https://github.com/simatic-ax/actions/pull/44 (github-actions)

### Changed
- Adds debug output of the event of the development workflow by in https://github.com/simatic-ax/actions/pull/49
- The workflows now make use of dedicated permissions. The automatic changelog update has been changed. by in https://github.com/simatic-ax/actions/pull/52
- The update of the changelog including the PR creation is now done inside a script by in https://github.com/simatic-ax/actions/pull/57

### Fixed
- Fixes the handling of secrets inside the GitHub workflows by in https://github.com/simatic-ax/actions/pull/46 (workflows)
- Fixes a malformed condition to allow uploading of artifacts during a workflow call by in https://github.com/simatic-ax/actions/pull/48 (development-workflow)
- Uploading artifacts now happens only in case of a release being run by in https://github.com/simatic-ax/actions/pull/50 (development-workflow)
- Fixes a path issue that caused a script run to fail by in https://github.com/simatic-ax/actions/pull/51 (release-workflow)
- Extends the permissions of the development workflow by in https://github.com/simatic-ax/actions/pull/53
- Marks the workspace directory of the CI pipeline as safe for git operations by in https://github.com/simatic-ax/actions/pull/54
- Alters the used workspace variable inside the release workflow by in https://github.com/simatic-ax/actions/pull/55

