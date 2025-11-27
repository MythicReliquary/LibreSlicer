# Measurement Tool

## At a Glance
- On-screen calipers to measure distances, angles, and diameters directly in LibreSlicer.
- Useful for verifying STL tolerances before printing modifiers or mating parts.

## Prerequisites
- Model loaded.
- Advanced UI layout (tool appears in left toolbar by default).

## Workflow
1. Activate the Measurement tool from the gizmo toolbar.
2. Click two points to measure linear distance; hold Ctrl to snap to axes.
3. Switch to `Diameter` mode for circular selections or `Angle` mode for three-point measurements.
4. Copy the measurement readout if you need to document it in commit messages or bug reports.

## Verification
- Compare results with the original CAD dimensions when possible.
- Use multiple measurements to confirm the mesh is uniformly scaled.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Tool selects build plate | Z clipping plane active | Zoom closer or temporarily hide other objects. |
| Values change after slicing | Autocenter/rotate enabled | Re-measure after locking the part position. |

## Related Resources
- [Simplify-Mesh](Simplify-Mesh.md)
- [Cut-Tool](Cut-Tool.md)
