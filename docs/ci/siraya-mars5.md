# Siraya Tech Mars 5 CI workflow

This document explains how the resin slicing regression checks are wired for the Elegoo Mars 5
using the Siraya Tech calibration models.

## Overview

The GitHub Actions workflow `.github/workflows/siraya-mars5.yml` builds a PrusaSlicer/UVTools
based toolchain and slices every STL declared in `third_party/siraya_test_models/manifest.json`.
For each entry the pipeline:

1. Fetches the STL (if a direct mirror is provided via `download_url`).
2. Slices it with the Mars 5 profiles stored in `ci_profiles/` via
   `scripts/ci_slice_and_validate.sh`.
3. Converts the intermediate SL1 archive to CTB with UVTools while applying basic
   `--analyze --fix` checks.
4. Publishes the CTB, UVTools report, preview PNG, and `COMPLIANCE/SOURCE_OFFER.md` as build
   artifacts.

## Toolchain components

| Tool            | Version pin (workflow)              | Purpose                                 |
|-----------------|-------------------------------------|-----------------------------------------|
| PrusaSlicer     | `PRUSASLICER_VERSION` env variable  | Headless slicing + SL1 export           |
| UVTools         | `UVTOOLS_VERSION` env variable      | CTB conversion, validation, reporting   |
| ImageMagick     | Ubuntu package `imagemagick`        | Preview rendering fallback              |
| Python scripts  | `scripts/fetch_siraya_models.py`    | Model mirroring and hash verification   |

Update the pinned versions in the workflow whenever upstream publishes security fixes or format
updates. Prefer mirroring the AppImages on company storage for deterministic builds.

## Preparing the models

1. Add each STL you want covered to `third_party/siraya_test_models/manifest.json` with the
   attributes documented in the file. If direct redistribution is not allowed, leave
   `download_url` empty and manually stage the STL on the runner (e.g. via artifact download).
2. Run `python scripts/fetch_siraya_models.py --strict` locally to ensure checksums and download
   links are valid.
3. Commit the STL (Git LFS recommended for large files) or update runner provisioning to ensure
   the file is present at runtime.

`v5_placeholder.stl` ships as a small cube so that the workflow can be tested without the official
Siraya Tech geometry. Replace it with the authentic mesh for production use.

## Anti-aliasing / resin sweeps

The workflow matrix demonstrates how to cover multiple anti-aliasing levels and resin exposures.
Extend it by editing `matrix.aa` and `matrix.resin` inside the workflow file. For new resin
variants, clone `ci_profiles/mars5_resin_siraya.ini` and point the matrix entry to the new profile
path.

## Local execution

Use the helper script to mirror the workflow locally:

```bash
scripts/fetch_siraya_models.py --strict
scripts/ci_slice_and_validate.sh --stl third_party/siraya_test_models/v5_placeholder.stl --aa 0 --variant local-aa0
```

Set `PRUSA_CLI` and `UVTOOLS_CLI` environment variables if the binaries live outside
`tools/`.

When validating local IDE changes before opening a pull request, run the helper script
against any mirrored Siraya models and inspect the generated `out/` artifacts. This
mirrors the CI workflow and provides confidence before the hosted checks execute.
