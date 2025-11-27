# Configuration Snapshots

## At a Glance
- Capture the entire configuration tree (print, filament, printer presets + application prefs) at a point in time.
- Essential for testers who need to revert after experimenting with beta profiles.

## Prerequisites
- LibreSlicer configuration directory writable.
- Optional: version control for the `snapshots` folder if sharing with teammates.

## Workflow
1. `Configuration > Take Configuration Snapshot` from the main menu.
2. Provide a descriptive name (e.g., `1.0.0-clean-room` or `support-tuning`).
3. Use `Configuration > Configuration Snapshots...` to review, export, or activate stored states.
4. When activating, decide whether to overwrite current unsaved presets.

## Screenshots
![Configuration snapshot dialog](images/configuration-snapshots.png "Snapshot list and activate button")

## Verification
- `Edit > Preferences > Data` shows the active snapshot ID.
- Inspect the `snapshots/` directory; each entry contains `config.ini` and metadata.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Snapshot missing | Data dir relocated | Check `--datadir` CLI flag or `Preferences > Folders`. |
| Activation fails | Presets incompatible with new version | Re-run the Configuration Wizard or delete stale vendor bundles. |

## Related Resources
- [Reload-From-Disk](Reload-From-Disk.md)
- [Template-Filaments](Template-Filaments.md)
