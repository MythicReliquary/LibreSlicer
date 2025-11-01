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

## Notes

- When vcpkg is present, the script auto-detects `.\vcpkg\scripts\buildsystems\vcpkg.cmake` and enables manifest mode.
- OpenVDB + TBB are required for hollowing and drainage features.
- Include `COMPLIANCE/SOURCE_OFFER.md` in release artifacts to stay AGPL compliant.
