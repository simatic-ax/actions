# Changelog

## [4.4.1] - 2026-10-26
### Added
- apax-make
    - New action that runs the `apax make` command, the successor of `apax build`
    - Updated the `actions-test` test project to use `make.yml` with the `@ax-as/s7-sdk` and `@ax-as/s7-catalog` packages (`^2610.0.0`), to validate the new action

### Changed
- apax-test
    - The `log-level` input is now forwarded as `--log-level` instead of `--loglevel`, following the [Breaking] CLI rename in `@ax-as/axunit` 10.0.126.
    - The deprecated `loglevel` input is forwarded as `--loglevel` again, so projects using an older AxUnit (e.g. `@ax/sdk` 2510) keep a working option. Use `log-level` with `@ax-as/axunit` 10.0.126 or later.
    - Note for users of `log-level` with an older AxUnit (e.g. `@ax/sdk` 2510): this AxUnit does not know `--log-level`; switch to the `loglevel` input or update AxUnit.
- Development workflow
    - Uses `apax-make` instead of `apax-build` and sets `log-level: debug` for `apax-test`.

## [4.4.0] - 2026-10-19
### Changed
- Bumped the reference CI image from `ghcr.io/simatic-ax/ci-images/apax-ci-image:4.3.0` to `ghcr.io/simatic-ax/ci-images/apax-ci-image:4.4.0` in all workflows, action READMEs, main README and documentation. The action interfaces are unchanged; all used apax commands and options are compatible with apax 4.4.0.
- `actions-test`: updated catalog `@ax/simatic-ax` to `^2510.21.0` and `@ax/sdk` to `2510.21.0`.
- `apax-test/README.md`: added a "Logging" section.

### Fixed
- `apax-build/README.md`: documented logging for the contributed `apax build` command (`verbose` for the build tool, `--log <level>` in `apax-build-args` for the compiler `stc`) and restored `--log Debug` in the example. The 4.3.0 statement that `--log` in `apax-build-args` fails was wrong: the arguments are forwarded to `stc`, which supports `--log`.

## [4.3.0] - 2026-08-12
### Added
- New `apax-doctor` action wrapping `apax doctor` for CI preflight checks (authentication, registry connectivity, environment, project state, ...). Available since apax 4.2.
- New optional `log-level` input on core-command actions `apax-install`, `apax-login`, `apax-pack`, `apax-publish`, `apax-self-update`, `apax-doctor` and `apax-version`. Accepts `trace`, `debug` or `info` and is forwarded as `--log <level>` to the apax CLI (apax core commands each expose this option).
- New optional `log-level` input on `apax-test`. Accepts `info` or `debug` and is forwarded as `--loglevel <level>`. `apax test` is a contributed command (from `@ax/axunit`) that exposes its own log option and does not support `trace`.
- New optional `verbose` input on `apax-build` (boolean). When `true`, forwards `--verbose` to `apax build`. `apax build` is a contributed command and does not accept the apax core `--log` option.
- New `ignore-scripts` input on `apax-test` action (correct spelling; supersedes the previous typo alias).
- Prerequisites sections in `apax-build/README.md` and `apax-test/README.md` clarifying that these commands are contributed (require `apax install` and matching packages in `apax.yml` beforehand).

### Changed
- Bumped the reference CI image from `ghcr.io/simatic-ax/ci-images/apax-ci-image:4.0.0` to `ghcr.io/simatic-ax/ci-images/apax-ci-image:4.3.0` in all workflows, action READMEs, main README and documentation.
- `apax-publish` now validates the `tag` input client-side against the apax 4.3 tag rules (must be lowercase, must not start with a digit or the letter `v`, must not be a valid semantic version) and fails with a clear error message instead of forwarding an invalid tag to `apax publish`.
- `apax-test`: the previous `loglevel` input (which was case-sensitive and defaulted to `Info`, so the default never matched) is superseded by `log-level`. Values are now normalized to lowercase and validated against `info`, `debug` (not `trace`, which the underlying `apax test` command does not support).
- `apax-test`: setting both `log-level` and `loglevel`, or both `ignore-scripts` and `ingore-scripts`, now fails with a clear error message (mutually exclusive inputs).

### Deprecated
- `apax-test` input `ingore-scripts` (typo). Use `ignore-scripts` instead. The old input is still accepted but emits a deprecation warning and will be removed in a future major version.
- `apax-test` input `loglevel`. Use `log-level` instead. The old input is still accepted but emits a deprecation warning and will be removed in a future major version.

### Fixed
- `apax-install`: removed dead reference to the previously removed `verbose` input. The input was already removed from the action contract in 4.0.0 but the shell code still tried to evaluate it and would have forwarded an unsupported `--verbose` flag to `apax install`.
- `apax-install/README.md`: removed the obsolete "Not Yet Supported Parameters" entry for `installStrategy`, which no longer exists in apax 4.x.
- `apax-build`: removed the previously added `log-level` input; `apax build` is a contributed command and does not accept `--log`. Replaced with `verbose` (see Added).
- `apax-build/README.md`: removed `--log Debug` from the example `apax-build-args`, which would have failed at runtime because `apax build` does not accept `--log`.
- `apax-build/README.md`: fixed "Failure Scenarios" numbering (was starting at `2.`).
- `apax-version/README.md`: fixed typo `simatic-ax/ations/apax-version@v4` -> `simatic-ax/actions/apax-version@v4` in the example workflow.
- `apax-self-update/README.md`: fixed title heading level (was `###`, now `#`).
- `apax-templatify/README.md`: removed duplicate `working-directory` entry (was listed under both Mandatory and Optional Parameters) and corrected the `registry-url` description.
- `apax-test/README.md`: added missing `@v4` version tag to the example `uses: simatic-ax/actions/apax-test` step.

## [4.0.0] - 2025-11-14
### Changed
- apax-install
    - Removed the redownload parameter
    - Removed the copy-local parameter
    - Removed the verbose parameter for detailed output during installation
- apax-pack
    - [Breaking] Replaced the `key-version-v2` input with `key-version` (optional, default: v1) with validation (format: v followed by integer)
    - `--key` and `--keyVersion` are now always passed to `apax pack`
- Development workflow
    - New required input `version` and a new `apax-version` step; the release workflow passes the release tag name
- Bumped the reference CI image from `ghcr.io/simatic-ax/ci-images/apax-ci-image:3.5.0` to `ghcr.io/simatic-ax/ci-images/apax-ci-image:4.0.0` and the action references in the workflows from `@v3` to `@v4`
- CODEOWNERS now point to the team `@simatic-ax/toa-teamofaxion`

## [3.5.0] - 2025-05-09
### Added
- New `application-example-release-workflow` to release a template based on the current repository
- apax-templatify
    - New inputs `working-directory`, `author`, `description`, `registry-scope` and `registry-url`
- Development workflow
    - Checks the links in modified Markdown files

### Changed
- apax-templatify
    - The package name is read more robustly from `apax.yml`
- Development workflow
    - Runs on pushes to `main` only and on pull requests against any branch
- `actions-test`: uses the catalog `@ax/simatic-ax` and `@ax/sdk` `^2504.0.0`; removed `installStrategy` and `apaxVersion`
- Bumped the reference CI image from `ghcr.io/simatic-ax/ci-images/apax-ci-image:3.4.2` to `ghcr.io/simatic-ax/ci-images/apax-ci-image:3.5.0`

### Removed
- `repo-maintenance-workflow` and `templatify-workflow`

## [3.4.2] - 2025-03-01

### Added
- Introduces GitHub actions to build a complete CI/ CD workflow

### Changed
- Adds debug output of the event of the development workflow
- The workflows now make use of dedicated permissions. 
- The automatic changelog update has been changed.
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
