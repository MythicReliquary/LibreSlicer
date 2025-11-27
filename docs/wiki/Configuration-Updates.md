# Configuration Updates

## At a Glance
- Describes how LibreSlicer distributes vendor bundles, how users opt in/out, and what happens when presets are incompatible.
- Replaces the legacy Prusa wiki entry so we can evolve the policy in-repo.

## Prerequisites
- Understanding of vendor bundles (`resources/profiles/*`) and the cache directory.
- Knowledge of the `PresetUpdater` feature flags introduced in LibreSlicer v1.0.

## Workflow
1. Explain the supported distribution channels (bundled vs. optional add-on packs).
2. Document how to trigger a manual check (`Configuration > Check for configuration updates`).
3. Provide guidance for restoring defaults, importing user presets, and recovering from incompatibilities.

## Verification
- Include CLI commands or UI cues that confirm an update ran (log excerpts, notification text).
- Link to sample presets so contributors can test.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| “Version mismatch” dialog | Vendor bundle older/newer than expected | Walk through using Configuration Snapshots or re-running the wizard. |
| Updates disabled | Feature toggles forced off | Explain how add-on packs supply safe URLs + flags. |

## Related Resources
- [Configuration-Snapshots](Configuration-Snapshots.md)
- `src/slic3r/Utils/PresetUpdater.cpp` developer notes
