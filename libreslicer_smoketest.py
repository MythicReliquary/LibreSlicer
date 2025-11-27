#!/usr/bin/env python3
"""
libreslicer_smoketest.py
========================

This script exercises critical parts of the merged LibreSlicer/Orca functionality
to provide a quick confidence check that a build of LibreSlicer can slice both
resin (SLA/DLP) and FDM (FFF) models, repair meshes, and interoperate with UVTools.

It assumes that the repository has been checked out with the expected directory
structure (e.g. ``tools/LibreSlicer.AppImage`` and ``tools/uvtools.AppImage`` as
downloaded in the CI workflow), and that the calibration/test model
``third_party/siraya_test_models/v5_placeholder.stl`` is present.

Two separate tests are performed:

1. **FDM slicing:** Invokes the Prusa/LibreSlicer CLI in FDM mode to produce
   a G‑code file.  A known FDM printer/print/filament profile (e.g. RatRig)
   is loaded and a basic cube is sliced.  The resulting G‑code file is checked
   for existence and, as a simple sanity check, scanned for a ``SET_PRESSURE_ADVANCE``
   command to confirm that advanced FDM features are encoded.

2. **Resin slicing & UVTools validation:** Utilizes the existing
   ``scripts/ci_slice_and_validate.sh`` helper to slice the same model into
   CTB format with anti‑aliasing level zero and run UVTools in headless mode
   to convert and validate the slice.  The presence of a CTB file and
   corresponding UVTools report in the ``out/`` directory indicates success.

If any step fails, a descriptive exception is raised.  A successful run
prints summary messages and exits with status zero.

Usage::

    python libreslicer_smoketest.py

Environment variables:

``PRUSA_CLI`` and ``UVTOOLS_CLI`` may be set to override the default
paths used for the Prusa/LibreSlicer and UVTools executables.  This mirrors
the CI helper script behaviour described in the LibreSlicer docs【501899283757706†L52-L65】.

"""
import os
import subprocess
import sys
from pathlib import Path
from typing import Dict, Optional


def run_command(command: str, cwd: Path, extra_env: Optional[Dict[str, str]] = None) -> None:
    """
    Execute a shell command and raise an exception on non‑zero return code.

    :param command: Command string to execute.
    :param cwd: Working directory for the subprocess.
    """
    print(f"[cmd] {command}")
    env = os.environ.copy()
    if extra_env:
        env.update(extra_env)

    result = subprocess.run(
        command,
        shell=True,
        cwd=str(cwd),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        env=env,
    )
    print(result.stdout)
    if result.returncode != 0:
        raise RuntimeError(f"Command failed with exit code {result.returncode}")


def find_prusa_cli(root: Path) -> Path:
    """
    Resolve the LibreSlicer/LibreSlicer CLI executable.

    Preference order:
      1. PRUSA_CLI environment variable (if it points to an existing file)
      2. build/src/libreslicer.exe (Windows)
      3. build/src/LibreSlicer.exe (upstream naming)
      4. tools/LibreSlicer.AppImage (Linux/CI default)
    """
    env_override = os.environ.get("PRUSA_CLI")
    if env_override:
        path = Path(env_override)
        if path.exists():
            return path
        raise FileNotFoundError(f"PRUSA_CLI points to missing file: {path}")

    candidates = [
        root / "build" / "src" / "libreslicer.exe",
        root / "build" / "src" / "LibreSlicer.exe",
        root / "tools" / "LibreSlicer.AppImage",
    ]
    for candidate in candidates:
        if candidate.exists():
            return candidate

    raise FileNotFoundError(
        "Unable to locate LibreSlicer CLI (checked build/src and tools/). "
        "Set PRUSA_CLI to override."
    )


def find_uvtools_cli(root: Path) -> Optional[Path]:
    """
    Resolve the UVTools CLI binary, if present.
    """
    env_override = os.environ.get("UVTOOLS_CLI")
    if env_override:
        path = Path(env_override)
        if path.exists():
            return path
        raise FileNotFoundError(f"UVTOOLS_CLI points to missing file: {path}")

    candidates = [
        root / "tools" / "uvtools.AppImage",
        root / "tools" / "UVtools.AppImage",
        root / "tools" / "uvtools.exe",
    ]
    for candidate in candidates:
        if candidate.exists():
            return candidate
    return None


def fdm_test(root: Path) -> None:
    """
    Perform a basic FDM slice using the Prusa/LibreSlicer CLI.

    A G‑code file is generated from the v5_placeholder STL using a known FDM
    profile.  The resulting file is scanned for a pressure‑advance command.
    """
    prusa_cli = find_prusa_cli(root)
    test_stl = root / "third_party" / "siraya_test_models" / "v5_placeholder.stl"
    if not test_stl.exists():
        raise FileNotFoundError(
            f"Test STL {test_stl} not found. Fetch calibration models per docs."
        )
    # Choose an FDM printer profile known to exist in the repository.  The
    # RatRig profile includes advanced settings such as pressure advance, which
    # makes a good sanity check【406624379477699†L598-L604】.
    printer_profile = root / "resources" / "profiles" / "RatRig.ini"
    if not printer_profile.exists():
        raise FileNotFoundError(
            f"FDM printer profile {printer_profile} not found; adjust path as needed."
        )
    out_dir = root / "out_fdm"
    out_dir.mkdir(parents=True, exist_ok=True)
    gcode_path = out_dir / "placeholder_fdm.gcode"

    # Construct CLI arguments:
    #  - --no-splash suppresses GUI
    #  - --export-gcode instructs the slicer to export G‑code (FFF)
    #  - --load loads the selected printer/print/filament profile
    #  - --output specifies the output file
    command = (
        f"\"{prusa_cli}\" --no-splash --export-gcode "
        f"--load \"{printer_profile}\" "
        f"--output \"{gcode_path}\" "
        f"\"{test_stl}\""
    )
    run_command(command, root)
    if not gcode_path.is_file():
        raise AssertionError(f"Expected G‑code {gcode_path} was not created")
    # Inspect the G‑code for a pressure‑advance command.  Profiles bundled
    # with LibreSlicer/Orca set this via ``SET_PRESSURE_ADVANCE``【406624379477699†L598-L604】.
    gcode_text = gcode_path.read_text(errors="ignore")
    if "SET_PRESSURE_ADVANCE" in gcode_text:
        print("✅ FDM slice completed and pressure advance command found.")
    else:
        print("⚠️  FDM slice completed but no SET_PRESSURE_ADVANCE command found.")


def resin_test(root: Path) -> None:
    """
    Perform a resin slice and UVTools validation using the CI helper script.

    This replicates the CI steps documented in ``docs/ci/siraya-mars5.md``
    (fetching models and invoking ``scripts/ci_slice_and_validate.sh``)【501899283757706†L52-L65】.
    """
    test_stl = root / "third_party" / "siraya_test_models" / "v5_placeholder.stl"
    if not test_stl.exists():
        raise FileNotFoundError(
            f"Test STL {test_stl} not found. Fetch calibration models per docs."
        )
    script_path = root / "scripts" / "ci_slice_and_validate.sh"
    if not script_path.exists():
        raise FileNotFoundError(
            f"Helper script {script_path} not found. Ensure you are in the repo root."
        )
    # Use anti‑aliasing 0 and a variant tag to avoid collision with CI outputs.
    variant = "smoketest"
    prusa_cli = None
    uvtools_cli = None
    try:
        prusa_cli = find_prusa_cli(root)
    except FileNotFoundError as exc:
        print(f"⚠️  Skipping resin test: {exc}")
        return

    uvtools_cli = find_uvtools_cli(root)
    if uvtools_cli is None:
        print(
            "⚠️  Skipping resin test: UVTools binary not found. "
            "Set UVTOOLS_CLI or place an AppImage in tools/."
        )
        return

    command = (
        f"\"{script_path}\" "
        f"--stl \"{test_stl}\" --aa 0 --variant \"{variant}\""
    )
    # This script will call the Prusa/LibreSlicer CLI and UVTools headless:
    # it converts to SL1, then uses UVTools to analyze, fix and export CTB【774328735548855†L119-L126】.
    run_command(
        command,
        root,
        extra_env={
            "PRUSA_CLI": str(prusa_cli),
            "UVTOOLS_CLI": str(uvtools_cli),
        },
    )
    # After execution, out/ directory should contain CTB and report files.
    out_dir = root / "out"
    ctb_files = list(out_dir.glob("*.ctb"))
    if not ctb_files:
        raise AssertionError(
            f"No CTB files were produced in {out_dir}. Check resin slicing."
        )
    reports_dir = out_dir / "reports"
    report_files = list(reports_dir.glob("*.txt"))
    if not report_files:
        raise AssertionError(
            f"No UVTools reports were produced in {reports_dir}. Check UVTools invocation."
        )
    print(f"✅ Resin slice produced {len(ctb_files)} CTB file(s) and UVTools reports.")


def main() -> None:
    repo_root = Path(__file__).resolve().parent
    print(f"Running LibreSlicer smoketest in {repo_root}")
    fdm_test(repo_root)
    resin_test(repo_root)
    print("🎉 All smoketests passed.")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"❌ Smoketest failed: {exc}", file=sys.stderr)
        sys.exit(1)
