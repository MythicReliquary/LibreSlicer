# Siraya Tech Calibration Models

This directory mirrors the public calibration assets referenced at <https://siraya.tech/pages/siraya-tech-test-model> so the
CI pipelines can slice and validate them in a reproducible way.

## Adding / updating models

1. Update `manifest.json` with each model you want to exercise. Supply the upstream landing page in `source_page`. When a stable
   direct download location is available, fill `download_url` and `sha256` to enable automated mirroring via
   `scripts/fetch_siraya_models.py`.
2. Place the downloaded STL in this directory using the `filename` declared in the manifest. Git LFS is recommended if the file
   exceeds several megabytes.
3. Commit the STL together with the manifest update. If licensing forbids redistribution, leave `download_url` null and ensure the
   file is staged outside of version control on the CI runner before invoking the workflow.

## Placeholder geometry

`v5_placeholder.stl` is a minimal cube that allows the CI workflow to run in environments where the official Siraya Tech model
cannot be redistributed. Replace it with the authentic STL and update `manifest.json` when you are ready to slice the real
calibration part.
