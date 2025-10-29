# AegisSlicer — Windows Build (Release)

This is the minimal, battle-tested path to produce a Windows `.exe` with **resin** features (SLA) enabled.

## Prereqs

- Visual Studio 2022 Build Tools (MSVC, CMake, Ninja)
- NSIS (for the installer) — `choco install nsis`
- (Optional) vcpkg for dependencies (OpenVDB, TBB, Boost)

## One-liner (from repo root)

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_win_release.ps1
```

This will:
1. Configure (`Release`, x64) with `-DENABLE_SLA=ON -DUSE_OPENVDB=ON -DSLIC3R_STATIC=ON`.
2. Build the app.
3. Stage `dist/` and invoke NSIS to produce `AegisSlicer-<timestamp>.exe`.

## Notes

- If you use vcpkg, ensure `.\vcpkg\scripts\buildsystems\vcpkg.cmake` exists. The scripts auto-detect and wire it in.
- OpenVDB + TBB are required for **hollowing** and **drainage holes**.
- Keep the repo **internal** until public release; when distributing binaries, include `COMPLIANCE/SOURCE_OFFER.md` in your release files for AGPL compliance.