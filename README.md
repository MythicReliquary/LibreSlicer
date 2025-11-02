<p align="center">
  <img src="resources/icons/libreslicer_brand_wordmark.png" alt="LibreSlicer" width="520">
</p>

<h1 align="center">LibreSlicer</h1>
<p align="center"><em>Creator-first resin slicer. No telemetry. Prusa heritage.</em></p>

<p align="center">
  <a href="https://github.com/MythicReliquary/LibreSlicer/releases">
    <img src="https://img.shields.io/github/v/release/MythicReliquary/LibreSlicer?display_name=tag&sort=semver" alt="Latest release">
  </a>
  <a href="COMPLIANCE/SOURCE_OFFER.md">
    <img src="https://img.shields.io/badge/source-offer-6f3dc8.svg" alt="Source offer">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-AGPL_v3-blue.svg" alt="License: AGPL v3">
  </a>
  <a href="KNOWN_ISSUES.md">
    <img src="https://img.shields.io/badge/status-known%20issues-f97316.svg" alt="Known issues">
  </a>
</p>

## Quick Links

- Latest builds & changelog: [GitHub Releases](https://github.com/MythicReliquary/LibreSlicer/releases)
- Compliance bundle: [`COMPLIANCE/SOURCE_OFFER.md`](COMPLIANCE/SOURCE_OFFER.md)
- Documentation hub: [libreslicer.org/guide](https://libreslicer.org/guide)
- Transparent Commons tip jar: [libreslicer.org/support](https://libreslicer.org/support)
- One-pager overview: [`docs/ONE_PAGER.md`](docs/ONE_PAGER.md)
- Transparency ledger & roadmap: see [KNOWN_ISSUES.md](KNOWN_ISSUES.md) and pinned GitHub issues

## Why LibreSlicer?

LibreSlicer is Mythic Reliquary’s community build of the PrusaSlicer lineage with a resin-first focus and an AGPLv3 guarantee. You get the proven core engine with an explicit promise of:

- **Predictable output** — validated SLA profiles, deterministic slicing defaults, and reproducible build scripts.
- **Control & privacy** — no telemetry, offline workflow by default, scriptable CLI for production pipelines.
- **Compliance discipline** — every release ships matching source archives, third-party notices, and a maintained `SOURCE_OFFER`.
- **Prusa compatibility** — upstream-friendly patches plus continued support for the broader Slic3r ecosystem.

## Get LibreSlicer

- **Windows (v1.0 Supporter Build)** — Download the installer from the [latest release](https://github.com/MythicReliquary/LibreSlicer/releases). The build is unsigned today; SmartScreen will warn on first launch.
- **Linux** — Build from source following [doc/How to build - Linux et al.](doc/How%20to%20build%20-%20Linux%20et%20al.md). The README will always state when prebuilt packages become available.
- **macOS** — Notarized universal builds arrive in v1.1; for now reference the upstream [macOS guide](doc/How%20to%20build%20-%20Mac%20OS.md) if you want to experiment.

## Build From Source

We publish the exact toolchain setup used for every tagged build:

- [Windows build notes](docs/BUILD_WINDOWS.md) — MSVC + Ninja + NSIS pipeline (run from a VS Native Tools prompt).
- [Linux how-to](doc/How%20to%20build%20-%20Linux%20et%20al.md) — GTK3 wxWidgets default, Catch2 v3 test harness.
- [macOS how-to](doc/How%20to%20build%20-%20Mac%20OS.md) — upstream instructions until the v1.1 pipeline lands.
- [Reproducibility checklist](REPRODUCIBLE-BUILD.md) — hashes, environment variables, packaging scripts.

Every binary release is built from this repository, tagged, and accompanied by the corresponding source archive listed in [`COMPLIANCE/SOURCE_OFFER.md`](COMPLIANCE/SOURCE_OFFER.md).

## Feature Snapshot

- Cross-platform GUI (Windows / macOS / Linux) plus full CLI for farm automation.
- SLA resin workflow tooling (hollowing, drainage, adaptive antialiasing, custom supports).
- Multi-material FFF support, variable layer heights, advanced infill strategies, and post-processing hooks.
- G-code flavor coverage: RepRap, Marlin, Klipper, MakerBot, Mach3, Machinekit, and more.
- Continuous integration with Catch2-based smoke tests for resin profiles.
- Creator-friendly defaults layered atop the PrusaSlicer feature set.

## Roadmap & Launch Targets

- **v1.0 launch (current):** Windows installer, Linux source path, trimmed Help menu pointing to [libreslicer.org](https://libreslicer.org), baseline Elegoo SLA profiles.
- **v1.1 in progress:** Qidi X Max 3 and Elegoo Mars 5 profiles (Siraya Tech Fast Grey), macOS universal build + notarized DMG, restored Help menu content, proprietary CLI harness for simulated print QA.
- Track public work via [KNOWN_ISSUES.md](KNOWN_ISSUES.md) and the pinned GitHub issues labeled `roadmap` or `good first task`.

## Support LibreSlicer

- Tip jar (Transparent Commons): [https://libreslicer.org/support](https://libreslicer.org/support)
- One-page overview for partners: [`docs/ONE_PAGER.md`](docs/ONE_PAGER.md)
- Transparency ledger & release notes: [`RELEASE_NOTES_v1.0.0.md`](RELEASE_NOTES_v1.0.0.md) (future releases will extend this series)
- Contact: [support@mythicreliquary.com](mailto:support@mythicreliquary.com) · Press: [press@libreslicer.org](mailto:press@libreslicer.org)

## Contributing

- Review [CONTRIBUTING.md](CONTRIBUTING.md) for coding standards, PR workflow, and review expectations.
- Browse the pinned “Good first task” issues for onboarding-friendly work.
- Security or compliance concerns? Email [support@mythicreliquary.com](mailto:support@mythicreliquary.com) per [SECURITY.md](SECURITY.md).

## License & Credits

- License: [GNU AGPLv3](LICENSE)
- Third-party notices: [`THIRD_PARTY_NOTICES.txt`](THIRD_PARTY_NOTICES.txt)
- Credits: [`CREDITS.md`](CREDITS.md)
- LibreSlicer branding, icons, and documentation © Mythic Reliquary LLC. Upstream acknowledgements remain intact—see the credits and notices above for full attribution.
