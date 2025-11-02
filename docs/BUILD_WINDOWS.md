# LibreSlicer — Windows Build (Release)

This is the minimal, battle-tested path to produce a Windows `.exe` with resin (SLA) functionality enabled.

## Prereqs

- Visual Studio 2022 Build Tools (MSVC, CMake, Ninja)
- NSIS (`choco install nsis`)
- Optional: vcpkg for dependency management (OpenVDB, TBB, Boost)

## One-liner (from repo root)

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_win_release.ps1
```

The script:

1. Configures (Release, x64) with `-DENABLE_SLA=ON -DUSE_OPENVDB=ON -DSLIC3R_STATIC=ON`.
2. Builds LibreSlicer.
3. Stages `dist/` and invokes NSIS to produce `LibreSlicer-<timestamp>.exe`.
4. Copies `LICENSE`, `THIRD_PARTY_NOTICES.txt`, `CREDITS.md`, and `COMPLIANCE/SOURCE_OFFER.md`
   into the installer payload.

## Notes

- When vcpkg is present, the script auto-detects `.\vcpkg\scripts\buildsystems\vcpkg.cmake` and enables manifest mode.
- OpenVDB + TBB are required for hollowing and drainage features.
- Run a smoke test of the generated installer:
  1. Install LibreSlicer and ensure the splash screen says **Supporter Build v1.0**.
  2. Launch the app, open `tests/models/rook/rook.3mf`, slice, and export G-code.
  3. Uninstall via **Apps & Features**; confirm `%ProgramFiles%\LibreSlicer` is removed.
