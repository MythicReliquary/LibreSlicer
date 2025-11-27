# Prusa Specific G-codes

## At a Glance
- Catalogs legacy Prusa Research commands (M73, M907/M910 variants, MMU control codes) still referenced by presets.
- Helps LibreSlicer maintainers decide whether to retain, shim, or remove these codes.

## Prerequisites
- Understanding of Marlin firmware forks used on MK3/MK4/MMU platforms.
- Access to reference firmware or documentation for each command.

## Workflow
1. List each command (e.g., `M73`, `M907 K1`, `Tx`, `Tc`, `T?`, `M702 C`).
2. Document behavior, parameters, and safe replacements when running on non-Prusa firmware.
3. Provide guidance for cross-flashing or community printers (e.g., how to strip unsupported codes via post-processing).

## Verification
- Test generated G-code on Prusa hardware and on neutral firmware (Klipper/RRF) to identify incompatibilities.
- Keep sample macros or scripts that translate the commands when necessary.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Printer halts on Tx | Command unsupported | Add conditional logic in presets to emit Tx only when `printer_vendor == Prusa`. |
| Estimation mismatch | Missing M73 | Provide alternative progress reporting command for other firmware (M117, M73 P). |

## Related Resources
- [G-code-Macros](G-code-Macros.md)
- [Insert-Pause-or-Custom-G-code](Insert-Pause-or-Custom-G-code.md)
