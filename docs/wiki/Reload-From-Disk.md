# Reload From Disk

## At a Glance
- Refreshes a model after editing it externally, keeping modifiers/supports when possible.
- Prevents re-importing + reconfiguring the project manually.

## Prerequisites
- Project saved as 3MF or STL/OBJ residing on disk.
- External editor (CAD/sculpt) writes to the same file path.

## Workflow
1. Update the source mesh in your CAD tool and overwrite the file.
2. In LibreSlicer, right-click the part → `Reload from disk`.
3. Confirm the reload; modifiers persist if the object count/topology is compatible.
4. Re-slice to propagate geometry changes to G-code.

## Verification
- Compare before/after via the G-code preview or use `Diff` view in external tools.
- Check the console log for reload status messages.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Reload option disabled | Object originated from clipboard or is a modifier | Save it to disk or reload the parent part. |
| Supports reset | Topology change invalidated anchors | Re-create supports or keep anchor meshes consistent between versions. |

## Related Resources
- [Per-Model-Settings](Per-Model-Settings.md)
- [Configuration-Snapshots](Configuration-Snapshots.md)
