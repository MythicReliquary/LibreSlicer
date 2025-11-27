# Supporter Updater Pack

This document captures the design for the opt-in add-on that re-enables automatic update and vendor-profile syncing for vetted supporters. The core LibreSlicer repo ships with all networked features disabled; this pack restores them without compromising the default AGPL build.

## Goals
- Keep the base build privacy-preserving and offline-safe.
- Allow supporters to drop in a well-scoped overlay (CMake/toolchain + config) that provides:
  - A branded update checker pointing at Mythic Reliquary infrastructure.
  - Vendor profile archive/index URLs hosted by the project.
  - Optional telemetry hooks that remain opt-in and documented.
- Ensure the add-on can be versioned/revoked independently from the mainline.

## Deliverables
1. **CMake Preset Overlay**
   - `cmake/presets/SupporterUpdater.cmake` defines `LIBRESLICER_UPDATER=1`, `LS_DISABLE_UPDATE_CHECKER=0`, `LIBRESLICER_TELEMETRY_ENABLED=0` by default.
   - Injects `LIBRESLICER_VENDOR_HOST=updates.libreslicer.dev` (new toggle) so `PresetUpdater` can whitelist only Mythic endpoints.

2. **Config Seed**
   - Drop-in `resources/supporter/supporter_addon.ini` containing:
     - `version_check_url=https://updates.libreslicer.dev/releases/version.manifest`
     - `index_archive_url=https://updates.libreslicer.dev/vendor/vendor_indices.zip`
     - `profile_folder_url=https://updates.libreslicer.dev/vendor/profiles`
   - Installer/add-on installer writes these keys to the user’s `libreslicer.ini` under a dedicated `[supporter_pack]` block so they can be removed cleanly.

3. **Updater UI Adjustments**
   - Provide strings/resources in `docs/wiki/Configuration-Updates.md` describing the supporter workflow.
   - Add a badge in the About dialog (`Resources TBD`) showing when the add-on is active.

4. **Distribution Artifact**
   - Zip/tarball containing:
     - Overlay preset (`SupporterUpdater.cmake`).
     - Supporter config seed.
     - README + checksum/signature.
   - Optional PowerShell/Bash helper to copy files into the build/install tree.

## Implementation Steps
1. Update `src/slic3r/Utils/PresetUpdater.cpp` to honor a `LIBRESLICER_VENDOR_HOST` define:
   ```cpp
   #ifndef LIBRESLICER_VENDOR_HOST
   #define LIBRESLICER_VENDOR_HOST ""
   #endif
   ```
   - When non-empty, ensure every download URL starts with this host (use `boost::asio::ip::host_name` comparison) before permitting HTTP requests.
2. Teach `AppConfig::set_defaults()` to read supporter overrides from `supporter_addon.ini` if present (without touching the default).
3. Add installer hooks (NSIS, macOS pkg, AppImage) to detect the presence of the add-on and copy its config files.
4. Document operational procedures (rotation of manifests, TLS cert renewal) in `docs/addons/ops.md`.

## Security & Privacy Notes
- No telemetry by default; if the pack eventually enables metrics, wrap them in a separate macro and ensure opt-in UI.
- All download endpoints must be HTTPS with HSTS; publish checksums for every manifest.
- Provide a quick way to “factory reset” (CLI flag to purge supporter entries in `libreslicer.ini`).

## Open Questions
- Should the add-on be licensed separately (AGPL-compatible)?
- How will keys or supporter entitlements be distributed, if at all? (Current plan assumes public access.)
- Do we need delta updates or just release notifications?

Tracking issues: `#supporter-pack`, `#preset-updater`.
