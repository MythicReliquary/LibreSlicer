# LibreSlicer v1.0.0 Release Notes

## Highlights
- Windows 10/11: Fully tested, stable
- Linux (Ubuntu/Debian/Fedora): Builds and slices confirmed
- macOS: Beta — build compiles, but runtime untested (community QA requested)
- Rebrand finalized: UI, docs, and assets consistently use the LibreSlicer name, with installers and DMGs shipping the refreshed icons and metadata.

## Platform coverage
- Windows 10/11 ✅
- Linux (Ubuntu/Debian/Fedora) ✅
- macOS ❌ (beta, see below)

## macOS community testing
If you’re on macOS (Intel or Apple Silicon), please test LibreSlicer v1.0.0:
- Download the `.dmg` from the release.
- Drag to Applications.
- Open via right-click → Open (to bypass unsigned app warning).
- Report any startup or slicing errors here: https://github.com/MythicReliquary/LibreSlicer/issues

## Notes
- v1.0 is the first tagged LibreSlicer release after the Aegis Slicer rename.
- AGPLv3 compliance: LICENSE, SOURCE_OFFER.md, THIRD_PARTY_NOTICES.txt, and CREDITS.md are included in all artifacts.
- Branding assets are finalized in [`brand/`](brand/) and mirrored in the UI resources.
- Release artifacts (installers, DMGs, tarballs) are named with the `libreslicer-v1.0.0` pattern and pull their icons from [`resources/icons/`](resources/icons) built from the final LibreSlicer source art.
- For known issues, see KNOWN_ISSUES.md and open issues on GitHub.
