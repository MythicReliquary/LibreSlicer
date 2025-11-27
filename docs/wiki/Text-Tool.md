# Text Tool

## At a Glance
- Adds embossed or engraved text directly inside LibreSlicer without external CAD.
- Supports truetype fonts, alignment controls, and conversion to modifier meshes.

## Prerequisites
- Font installed on the OS (system fonts are enumerated).
- Model selected with sufficient surface area for the text.

## Workflow
1. Select the target face; open the `Text` tool from the gizmo toolbar.
2. Enter the string, choose font, size, and depth (positive for emboss, negative for engrave).
3. Position/rotate the text mesh; optionally convert it into a modifier (e.g., Negative Volume) for advanced effects.
4. Slice and review cross-sections to ensure legibility.

## Verification
- G-code preview should show additional perimeters/infill for embossed text or voids for engraving.
- Print a calibration plate to confirm the chosen font renders correctly at your nozzle size.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Jagged edges | Low resolution font conversion | Increase tessellation quality via Preferences > Advanced > Text tool resolution. |
| Letters missing | Text protrudes outside mesh | Move the text fully into/onto the surface or increase the target face size. |

## Related Resources
- [Negative-Volume](Negative-Volume.md)
- [G-code-Macros](G-code-Macros.md)
