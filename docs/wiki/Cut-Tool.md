# Cut Tool

## At a Glance
- Split models into sections for printability, orientation tweaks, or multi-color workflows.
- Supports plane cuts, custom angles, optional alignment pins.

## Prerequisites
- Model loaded in the 3D viewport.
- Advanced mode recommended for multi-part operations.

## Workflow
1. Select a model → right-click → `Cut...`.
2. Choose `Horizontal` or `Angled` cut; set the Z-height or angle numerically or via gizmo.
3. Decide whether to keep upper/lower parts, add dowel pins, or create connectors.
4. Slice each resulting part separately or group them if printing together.

## Verification
- Inspect the Object List for new parts (`upper` / `lower`).
- Preview the G-code to ensure pins or separation gaps exist as expected.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Parts misaligned after print | Dowel diameter mismatch | Adjust pin size based on printer calibration or disable automatic dowels. |
| Cut option greyed out | Support enforcer selected | Select the actual model part before invoking the tool. |

## Related Resources
- [Measurement-Tool](Measurement-Tool.md)
- [Text-Tool](Text-Tool.md)
