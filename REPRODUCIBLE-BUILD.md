# Reproducible Build Notes

This document explains how to reproduce LibreSlicer release binaries.

## Windows

1. Install Visual Studio Build Tools 2022 (MSVC, CMake, Ninja) and NSIS.
2. Optionally bootstrap vcpkg (manifest mode).
3. Run `powershell -ExecutionPolicy Bypass -File .\scripts\build_win_release.ps1`.

The script configures Release/x64 with `-DENABLE_SLA=ON -DUSE_OPENVDB=ON -DSLIC3R_STATIC=ON`, builds, stages `dist/`, and invokes NSIS to emit `LibreSlicer-<timestamp>.exe`.

## Toolchain Pins

- Dependency versions are pinned by `vcpkg.json` and `version.inc`.
- Build ID stamping occurs through the CMake configuration flow.

Signing keys are kept private; CI documents where signing would occur but does not expose certificates.
