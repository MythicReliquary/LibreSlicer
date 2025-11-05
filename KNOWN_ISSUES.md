# Known Issues and Platform Coverage (v1.0.0)

## Platform coverage
- **Windows 10/11** ✅ — fully tested
- **Linux (Ubuntu/Debian/Fedora)** ✅ — builds and slices confirmed
- **macOS** ❌ — community testing requested; initial build compiles but unverified runtime

## macOS community testing
If you’re on macOS (Intel or Apple Silicon), please test LibreSlicer v1.0.0:
- Download the `.dmg` from the release.
- Drag to Applications.
- Open via right-click → Open (to bypass unsigned app warning).
- Report any startup or slicing errors here: https://github.com/MythicReliquary/LibreSlicer/issues

## Other known issues
- Linux builds from source currently fail during the CMake configuration step when CGAL
  development headers are unavailable on the system. The configure process stops with
  `Could not find a package configuration file provided by "CGAL"`. Install the CGAL
  development package (for example, `sudo apt install libcgal-dev`) or point `CGAL_DIR`
  to an existing installation before running CMake.
- See open issues on GitHub for the latest details.
