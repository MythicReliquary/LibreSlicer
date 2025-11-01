# LibreSlicer
> Creator‑first resin slicer. No telemetry. Prusa / Orca lineage.

LibreSlicer is a Mythic Reliquary community build of the PrusaSlicer / OrcaSlicer
line. We focus on SLA/resin workflows, predictable release cadence, and keeping
the project compliant with the GNU Affero GPLv3. The binaries we distribute are
built from this repository; every release contains the corresponding `SOURCE_OFFER.md`
alongside the installer.

- **Latest builds:** see the [Releases page](https://github.com/MythicReliquary/LibreSlicer/releases).
- **Source offer:** `COMPLIANCE/SOURCE_OFFER.md` (also shipped inside each release).
- **License:** GNU AGPLv3 (see `LICENSE`). Third-party notices live in `THIRD_PARTY_NOTICES.txt`.

## Support & Issue Tracking

- File bugs or feature requests here: [MythicReliquary/LibreSlicer issues](https://github.com/MythicReliquary/LibreSlicer/issues/new/choose)
- Review open problems: [KNOWN_ISSUES.md](KNOWN_ISSUES.md)

## Feature Snapshot

LibreSlicer inherits a large feature set from PrusaSlicer/OrcaSlicer, including:

- Cross-platform GUI (Windows / macOS / Linux) plus full command-line interface
- Multi-material and multi-extruder support
- SLA resin workflow (hollowing, drill, drainage, custom supports)
- Wide G-code flavor coverage (RepRap, Marlin, Klipper, MakerBot, Mach3, Machinekit, …)
- Advanced infill and shell controls, variable layer heights, spiral vase mode
- Built-in post-processing scripts, custom G-code macros, dynamic cooling logic
- Extensive unit tests and continuous integration

LibreSlicer additions emphasize creator-friendly defaults, resin QA pipelines, and
compliance automation. See release notes for changes per build.

## Build From Source

We ship scripts and docs for reproducible builds:

- [Windows](docs/BUILD_WINDOWS.md) – MSVC + Ninja + NSIS one-liner
- [macOS](doc/How%20to%20build%20-%20Mac%20OS.md) (upstream instructions still apply)
- [Linux](doc/How%20to%20build%20-%20Linux%20et%20al.md)
- [Reproducibility notes](REPRODUCIBLE-BUILD.md)

## Contributing

Check out [CONTRIBUTING.md](CONTRIBUTING.md) for coding standards, PR expectations,
and release-branch etiquette. Pull requests and community profiles are welcome.
Please open an issue first for significant reworks so we can plan review bandwidth.

Security reports should go to [support@mythicreliquary.com](mailto:support@mythicreliquary.com)
as documented in [SECURITY.md](SECURITY.md).

## Credits & Upstream References

- Based on [PrusaSlicer](https://github.com/prusa3d/PrusaSlicer) and the original
  [Slic3r](https://github.com/Slic3r/Slic3r) by Alessandro Ranellucci.
- Draws inspiration and fixes from the [OrcaSlicer](https://github.com/SoftFever/OrcaSlicer) community.
- Some historical documentation lives in the upstream `doc/` directory; retain upstream
  references for advanced topics and macro syntax.

LibreSlicer branding, icons, and documentation are © Mythic Reliquary LLC. Upstream
credits and third-party license obligations remain intact—see `CREDITS.md` and
`THIRD_PARTY_NOTICES.txt` for details.
