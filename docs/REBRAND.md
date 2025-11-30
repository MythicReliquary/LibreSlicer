# Rebrand Notice — Aegis Slicer → LibreSlicer

**Effective date:** October 28, 2025  
**Project:** LibreSlicer (formerly Aegis Slicer)  
**Website:** https://libreslicer.org

## Why we renamed
“LibreSlicer” states our values in the name: creator-first, open core (AGPLv3), and no telemetry. Same code lineage, same team—clearer direction.

## What changed (and what didn’t)
- **Changed:** Name, website domain, on-page branding, release tags, docs, and in-app resources.
- **Unchanged:** License (AGPLv3 for the Supporter Build), funding model (Transparent Commons), and clean-room Hephaestus Pro track.

## Timeline
- **Oct 28, 2025:** Public rebrand; banner + news post; repo docs updated.
- **Oct 28–Nov 30, 2025:** 301 redirects active; “formerly Aegis Slicer” note visible.
- **Nov 3–9, 2025:** Transparency Patch #1 includes rebrand ledger entry.

## Repository & releases
We are **keeping the current repo slug** for continuity (GitHub auto-redirects are reliable if we later rename). New releases will use `libreslicer-vX.Y.Z` tags and include the finalized LibreSlicer branding baked into binaries and resource bundles.
- Source art is in [`brand/`](../brand/) and compiled application icons live in [`resources/icons/`](../resources/icons/) (LibreSlicer*.png/ico/icns).
- Installers, DMGs, and portable zips should all ship with LibreSlicer naming/metadata and the refreshed icons from `resources/icons/`.
- Keep installer manifests pointing to the compiled `resources/icons/` outputs so bundle metadata stays aligned with the LibreSlicer name and art.

### Verify the rebrand is complete
- Run `./scripts/verify_rebrand.sh` to ensure no legacy "Aegis Slicer" references remain outside of this notice and the historical release notes.
- Add new ignore globs to the script if you need to preserve historical mentions in additional archival documents.

## Redirects & mapping
All legacy `aegisslicer.org` links 301 to `libreslicer.org`.  
Slug-by-slug mapping lives here:


Add one per line: <old-path> -> <new-path> 301

/news -> /news 301
/press -> /news 301
/faq -> /faq 301
/roadmap -> /roadmap 301
/ledger -> /ledger 301
/aegis -> /about 301


> If you find a broken link, please open an issue or email support@libreslicer.org.

## Legal & compliance
- Supporter Build remains AGPLv3 with **SOURCE_OFFER** included in every release bundle.
- **NOTICE** updated to reflect the new project name while preserving historical credits.
- Keep build notes synced:
  - Linux defaults to GTK3 wxWidgets (`SLIC3R_GTK=3`).
  - Tests rely on Catch2 v3.x (ensure Windows toolchain pulls the same version).
- No telemetry at launch; diagnostics remain optional/opt-in in a later version.

## Contact
- Support: support@libreslicer.org
- Press: press@libreslicer.org
