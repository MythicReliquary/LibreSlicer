# Simplify Mesh

## At a Glance
- Reduces triangle count to speed up slicing/rendering without returning to CAD.
- Useful for scanned models or decorative assets with millions of facets.

## Prerequisites
- LibreSlicer 3D view in Advanced/Expert mode.
- Original model loaded; optionally duplicate it so you can compare results.

## Workflow
1. Select the model in the Object List.
2. Right-click → `Simplify model...` to open the dialog.
3. Set a target triangle count or deviation tolerance; enable `Keep shape features` for mechanical parts.
4. Preview the simplified mesh and accept once the deviation is acceptable.

## Verification
- Toggle `Wireframe` or `G-code preview` to ensure features remain intact.
- Measure critical dimensions with the Measurement Tool if accuracy matters.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Edges distorted | Tolerance too high | Lower the maximum deviation or enable feature preservation. |
| File size unchanged | Mesh already below target | Choose a lower triangle count or skip simplification. |

## Related Resources
- [Measurement-Tool](Measurement-Tool.md)
- [Cut-Tool](Cut-Tool.md)
