# Insert Pause or Custom G-code

## At a Glance
- Lets you pause mid-print for filament swaps or inject arbitrary commands at specific layers.
- Supports printer-specific macros (M600, M0, custom scripts) without editing the entire G-code file manually.

## Prerequisites
- Project sliced at least once so layers exist in the preview.
- Knowledge of the printer firmware commands you plan to insert.

## Workflow
1. Slice the model and open the `Preview` tab.
2. Move the layer slider to the desired height; click the `Add pause/cmd` icon or right-click the slider.
3. Choose `Pause print` (M0/M25), `Custom G-code`, or `Color change`.
4. Provide a message or script snippet; LibreSlicer stores it in `After layer change G-code` for that layer.

## Screenshots
![Insert pause dialog](images/insert-pause-dialog.png "Layer slider context menu for pauses")

## Verification
- Re-slice and inspect the G-code preview annotations (flags appear where events exist).
- Optionally open the exported G-code and search for `; inserted by LibreSlicer` comments.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Printer ignores pause | Firmware command unsupported | Map the action to a command your firmware accepts (e.g., M25 vs M0). |
| Resume starts with blob | No purge move | Extend the custom script to retract before pausing and prime after resuming. |

## Related Resources
- [G-code-Macros](G-code-Macros.md)
- [Configuration-Snapshots](Configuration-Snapshots.md)
