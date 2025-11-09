# Dependency Delta: LibreSlicer vs. Orca Drop

## Data sources
- `vcpkg.json` and `deps/+*/` inside `LibreSlicer-Supporter-Dev`
- `deps/` and `deps_src/` inside `Dirty_Merge/Orca/OrcaSlicer`

## Baseline (LibreSlicer)

| Source | Libraries / Packages |
|--------|----------------------|
| `vcpkg.json` | `tbb`, `nlopt`, `openvdb`, `imath`, `openexr`, `blosc`, `glew`, `eigen3`, `libpng`, `zlib`, `bzip2`, `curl`, `boost-*` (assign, beast, dll, log, locale), `cereal`, `freetype`, `harfbuzz`, `libjpeg-turbo`, `tiff`, `libzip`, `expat`, `libdeflate`, `openjph`, `qhull`, `cgal`, `gmp`, `catch2 >= 3.0.1`, `opencascade`, `wxwidgets` |
| `deps/+…` | `Blosc`, `Boost`, `CGAL`, `CURL`, `Catch2`, `Cereal`, `EXPAT`, `GLEW`, `GMP`, `JPEG`, `LibBGCode`, `MPFR`, `NLopt`, `NanoSVG`, `OCCT`, `OpenCSG`, `OpenEXR`, `OpenSSL`, `OpenVDB`, `PNG`, `Qhull`, `TBB`, `TIFF`, `ZLIB`, `heatshrink`, `wxWidgets` |

## Orca drop inventory

| Location | Libraries / Packages |
|----------|----------------------|
| `deps/` | `Blosc`, `Boost`, `CGAL`, `CURL`, `Cereal`, `EXPAT`, `FREETYPE`, `GLEW`, `GLFW`, `GMP`, `JPEG`, `MPFR`, `NLopt`, `NanoSVG`, `OCCT`, `OpenCSG`, `OpenCV`, `OpenEXR`, `OpenSSL`, `OpenVDB`, `PNG`, `Qhull`, `TBB`, `WebView2`, `ZLIB`, `libnoise`, `wxWidgets` plus platform-specific scripts (`deps-*.cmake`) |
| `deps_src/` | `Shiny`, `admesh`, `agg`, `ankerl`, `clipper`, `earcut`, `eigen`, `expat`, `fast_float`, `glu-libtess`, `hidapi`, `hints`, `imgui`, `imguizmo`, `libigl`, `libnest2d`, `mcut`, `minilzo`, `miniz`, `nanosvg`, `nlohmann`, `qhull`, `qoi`, `semver`, `spline`, `stb_dxt` |

## Notable differences

1. **Additional Orca dependencies**
   - GUI / platform: `GLFW`, `WebView2`
   - Vision / math: `OpenCV`, `libnoise`, `mcut`, `fast_float`
   - UI widgets: `imguizmo`, `Shiny`
   - Serialization / utility: `nlohmann`, `ankerl`
   - Geometry extras: `mcut`, `earcut`, `stb_dxt`

2. **Libraries only present in LibreSlicer manifests**
   - `LibBGCode`, `openjph`, `harfbuzz`, `libzip`, `libdeflate`, `bzip2`

3. **Version drift (needs confirmation)**
   - Catch2: LibreSlicer uses `>=3.0.1`, Orca still packages Catch2 v2 inside `deps/+Catch2`.
   - Boost/OpenSSL/etc. may be pinned to different commits; Orca’s `deps-*.cmake` reference prebuilt archives rather than vcpkg baselines.

4. **Build orchestration**
   - LibreSlicer relies on vcpkg baseline `21b5942…` and `deps/+…` convenience wrappers.
   - Orca uses bespoke `deps-<platform>.cmake` scripts plus `deps_src` copies for vendored code, which complicates upgrading licenses and security patches.

## Compliance considerations

- Any Orca-only third‑party additions require SPDX/NOTICE updates (e.g., OpenCV BSD, WebView2 MIT, libnoise LGPL).
- Catch2 downgrade (v2) is incompatible with our current test harness; migrating Orca’s tests to Catch2 v3 keeps the entire tree consistent.
- `deps_src` contains additional embedded code (imguizmo, nlohmann, stb). We need to audit licenses before integrating or replacing with vcpkg versions.

## Action items

1. **Decide baseline package manager**
   - Option A: Port Orca-specific deps to vcpkg (preferred for reproducibility).
   - Option B: Keep Orca’s `deps-*.cmake` but document provenance and automate checksum verification.

2. **Catch2 alignment**
   - Remove Orca’s bundled Catch2 v2 and switch its tests to the vcpkg Catch2 v3 already used by LibreSlicer (see failures in `test_support_spots_generator.cpp`, `sla_print_tests.cpp`).

3. **New dependency intake**
   - For each Orca-only library (OpenCV, WebView2, libnoise, etc.), determine if LibreSlicer needs the feature; if yes, add to vcpkg/bazel lists and update COMPLIANCE docs.

4. **Shared vendored code**
   - Compare `deps_src` copies (e.g., `imgui`, `libigl`, `libnest2d`, `qhull`) with LibreSlicer’s versions to ensure we don’t regress patches when merging.

5. **Documentation**
   - Keep this file updated as we integrate/dismiss dependencies so future merges know the status.

