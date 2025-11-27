# Printables Integration

## At a Glance
- Documents how LibreSlicer handles `printables:` links, browser integration, and authentication (if any).
- Applies to Windows/macOS installers and AppImage bundles that register URL handlers.

## Prerequisites
- Desktop OS with default browser set.
- LibreSlicer installed with URL handler enabled (see installer options).

## Workflow
1. Visit printables.com (or LibreSlicer community mirror) and click `Send to LibreSlicer` on a compatible model.
2. Confirm the browser prompt and allow it to open LibreSlicer.
3. LibreSlicer downloads the asset via the integrated downloader; watch the notification center.
4. Once imported, review the object list and apply desired presets.

## Screenshots
![Printables integration prompt](images/printables-integration.png "Browser prompt opening LibreSlicer")

## Verification
- Check `Help > System Info > URL handler` to verify registration.
- Inspect `%APPDATA%/LibreSlicer/cache/downloads` (or platform equivalent) for downloaded assets.

## Troubleshooting
| Symptom | Cause | Fix |
| --- | --- | --- |
| Nothing happens when clicking the link | URL handler not registered | Re-run the installer or toggle the registry entries via Preferences (Windows). |
| Download stuck | Firewall blocks CDN | Document the domains to whitelist or provide an offline import path. |

## Related Resources
- [Downloader subsystem docs TBD]
- [Configuration-Snapshots](Configuration-Snapshots.md)
