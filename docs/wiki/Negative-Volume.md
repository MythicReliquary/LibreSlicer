# Negative Volume

## At a Glance
- Negative volumes let you subtract helper meshes from a model to create sockets, holes, or channels without editing the source CAD.
- Works for FFF printers in Advanced/Expert mode; SLA currently ignores negative volumes.

## Prerequisites
- LibreSlicer Advanced or Expert mode.
- An existing model plus a modifier mesh (STL/3MF/OBJ) representing the void you want to carve.
- Basic understanding of the right-click `Add` menu in the 3D viewport.

## Workflow
1. **Import base model** and confirm it is manifold.
2. **Right-click the platter** → `Add` → `Part` → `Negative volume`, then choose the subtractive mesh.
3. **Position/scale** the negative volume using the Move/Scale gizmos; it should overlap the target area completely.
4. **Slice preview** to verify the void appears (perimeters/infill are omitted where the modifier intersects).

## Screenshots
![Negative Volume workflow](images/negative-volume-workflow.png "Negative volume modifier overlay")

## Verification
- Use the G-code preview to scrub through layers and confirm the cavity exists.
- Optional: export a 3MF project and re-open it to ensure the modifier is persisted.

## Troubleshooting
| Symptom | Likely Cause | Fix |
| Model not affected | Modifier type not set to Negative Volume | Select the part in the Object List → change its type dropdown to Negative volume. |
| Rough walls | Modifier mesh has low resolution | Re-export the subtractive mesh with higher polygon count or use the Simplify tool carefully. |

## Related Resources
- [Per-Model-Settings](Per-Model-Settings.md)
- [Cut-Tool](Cut-Tool.md)
