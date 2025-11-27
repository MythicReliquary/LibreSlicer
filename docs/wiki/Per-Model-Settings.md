# Per-Model Settings

## At a Glance
- Override slicing parameters on a per-object or per-region basis without duplicating entire presets.
- Critical for mixing layer heights, infill, or filament-specific tweaks inside a single project.

## Prerequisites
- Expert mode enabled (many per-model options hide in Simple mode).
- Object List visible with at least one model selected.

## Workflow
1. Select a model → click `Per-Model settings` (gear icon) or right-click → `Add modifier` → `Settings`. 
2. Choose the parameter group (e.g., `Layer Height`, `Infill`, `Speed`) and set overrides.
3. Optionally add modifier volumes to limit the override to specific regions.
4. Slice and review the preview legend to confirm overrides applied.

## Verification
- Inspect the `Object List` for orange indicators showing customized params.
- Use the `Preview` legend filter to ensure infill/line widths change only where expected.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Setting ignored | Override applied to wrong object/volume | Re-select the correct part or ensure the modifier volume intersects the mesh. |
| Too many overrides to track | No snapshot history | Use [Configuration-Snapshots](Configuration-Snapshots.md) before making bulk edits. |

## Related Resources
- [Negative-Volume](Negative-Volume.md)
- [Variable-layer height wiki entry once available]
