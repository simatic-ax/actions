# Changelog

## [4.3.0] - 2026-08-03
### Added
- New `apax-doctor` action wrapping `apax doctor` for CI preflight checks (authentication, registry connectivity, environment, project state, ...). Available since apax 4.2.
- New optional `log-level` input on `apax-build`, `apax-install`, `apax-login`, `apax-pack`, `apax-publish`, `apax-self-update`, `apax-test` and `apax-version` actions. Accepts `trace`, `debug` or `info` and is forwarded as `--log <level>` to the apax CLI.
- New `ignore-scripts` input on `apax-test` action (correct spelling; supersedes the previous typo alias).

### Changed
- Bumped the reference CI image from `ghcr.io/simatic-ax/ci-images/apax-ci-image:4.0.0` to `ghcr.io/simatic-ax/ci-images/apax-ci-image:4.3.0` in all workflows, action READMEs, main README and documentation.
- `apax-publish` now validates the `tag` input client-side against the apax 4.3 tag rules (must be lowercase, must not start with a digit or the letter `v`, must not be a valid semantic version) and fails with a clear error message instead of forwarding an invalid tag to `apax publish`.
- `apax-test`: the previous `loglevel` input (which was case-sensitive and defaulted to `Info`, so the default never matched) is superseded by `log-level`. Values are now normalized to lowercase and validated against `trace`, `debug`, `info`.

### Deprecated
- `apax-test` input `ingore-scripts` (typo). Use `ignore-scripts` instead. The old input is still accepted but emits a deprecation warning and will be removed in a future major version.
- `apax-test` input `loglevel`. Use `log-level` instead. The old input is still accepted but emits a deprecation warning and will be removed in a future major version.

### Fixed
- `apax-install`: removed dead reference to the previously removed `verbose` input. The input was already removed from the action contract in 4.0.0 but the shell code still tried to evaluate it and would have forwarded an unsupported `--verbose` flag to `apax install`.
- `apax-install/README.md`: removed the obsolete "Not Yet Supported Parameters" entry for `installStrategy`, which no longer exists in apax 4.x.

## [4.0.0] - 2025-11-14
### Changed
- apax-install
    - Removed the redownload parameter
    - Removed the copy-local parameter
    - Removed the verbose parameter for detailed output during installation
- apax-pack
    - Re-added the key-version parameter (optional, default: v1) with validation (format: v followed by integer)

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
