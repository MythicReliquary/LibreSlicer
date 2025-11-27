# Ironing

## At a Glance
- Performs a secondary skin pass with low extrusion to smooth the top layer of FFF prints.
- Best for visible top surfaces on PLA/PETG prints where sheen matters.

## Prerequisites
- Slicing mode: Advanced/Expert.
- Compatible filament profile (ironing works poorly on flexibles or SLA).

## Workflow
1. Navigate to `Print Settings > Advanced > Ironing`.
2. Enable `Enable ironing` and choose to apply it to `Top surfaces only` or `Every top surface`.
3. Tune flow, speed, and spacing; start with defaults when unsure.
4. Slice and review the Preview → `Color by feature` to confirm ironing moves exist.

## Verification
- The Preview should show a distinct thin pass in purple/skin color on top layers.
- After printing, inspect sheen uniformity; adjust flow if ripples remain.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Elephant skin / ridges | Flow too high or nozzle too hot | Lower ironing flow or temperature. |
| Feature missing | Model lacks horizontal top surface | Add a modifier volume or redesign to provide a flat top. |

## Related Resources
- [Infill-Patterns](Infill-Patterns.md)
- [Per-Model-Settings](Per-Model-Settings.md)
