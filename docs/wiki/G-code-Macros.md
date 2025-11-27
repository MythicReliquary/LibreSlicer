# G-code Macros

## At a Glance
- Central reference for placeholder variables (`[first_layer_temperature]`, `{if print_time > 1}`, etc.) usable inside custom G-code blocks.
- Describes evaluation order and firmware compatibility.

## Prerequisites
- Familiarity with `Printer Settings > Custom G-code` sections.
- Knowledge of the target firmware flavor (Marlin, Klipper, RRF, etc.).

## Workflow
1. Identify where the macro should run (start, layer change, tool change, end).
2. Insert placeholders using the `${}` or `[]` syntax described here.
3. Use conditional expressions for advanced flows; test with the `G-code preview` or `Dry-run` printers.
4. Document custom macros in your presets so other maintainers understand the intent.

## Verification
- Export G-code and search for the expanded values.
- Run small test prints to ensure firmware accepts the generated commands.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Placeholder printed literally | Syntax error | Use square brackets for legacy placeholders, curly braces for conditional logic. |
| Firmware halts | Command unsupported | Wrap vendor-specific commands in `if printer_notes contains` conditions. |

## Related Resources
- [Insert-Pause-or-Custom-G-code](Insert-Pause-or-Custom-G-code.md)
- [Prusa-Specific-G-codes](Prusa-Specific-G-codes.md)
