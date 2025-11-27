# Infill Patterns

## At a Glance
- Overview of the infill algorithms shipped with LibreSlicer (Grid, Gyroid, Adaptive Cubic, etc.).
- Highlights mechanical properties, print time impact, and slicer-specific tunables.

## Prerequisites
- Basic familiarity with `Print Settings > Infill` panel.
- Knowledge of printer constraints (nozzle size, material behavior) to interpret recommendations.

## Workflow
1. Choose the pattern from the dropdown; note which presets override it.
2. Adjust `Infill density`, `Line width`, and pattern-specific options (e.g., `Surface smoothing for gyroid`).
3. Use `Modifier meshes` to mix multiple patterns if required.
4. Preview using `Color Print` → `Feature type` to inspect infill flow.

## Verification
- Check the estimated print time vs. structural needs.
- For mechanical parts, print test coupons and record strength results to feed back into this page.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Infill not touching perimeters | Line width mismatch | Align infill width to perimeter width or enable `Ensure vertical shell thickness`. |
| Printer rattles | Non-orthogonal moves on CoreXY | Switch to rectilinear patterns for sensitive machines. |

## Related Resources
- [Ironing](Ironing.md)
- [Per-Model-Settings](Per-Model-Settings.md)
