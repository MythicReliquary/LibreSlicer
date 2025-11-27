# Template Filaments

## At a Glance
- Baseline filament presets meant for duplication, not direct printing.
- Explain how template presets differ from vendor-calibrated or user presets.

## Prerequisites
- Understanding of `Filament Settings` and how inheritance works.
- Configuration snapshots recommended before editing templates.

## Workflow
1. Duplicate the template filament (right-click → `Add copy`).
2. Rename the copy to match your material batch.
3. Calibrate temperatures, flow, cooling, and advanced parameters.
4. Save as user preset; avoid modifying the shipped template directly to prevent update conflicts.

## Screenshots
![Template filament preset list](images/template-filaments.png "Template filament badge and copy action")

## Verification
- Filament preset list should show a lock icon on templates and a user icon on your derived preset.
- Print a calibration tower to validate settings.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Template changed after update | Editing default preset | Always duplicate before editing; restore via Configuration Snapshots if needed. |
| Preset missing | Vendor bundle not installed | Re-run the Configuration Wizard or download the vendor pack. |

## Related Resources
- [Configuration-Snapshots](Configuration-Snapshots.md)
- [G-code-Macros](G-code-Macros.md)
