"""
Smoke-test automation for LibreSlicer GUI.

This script runs on Windows only. It can:
 - Launch LibreSlicer.exe
 - Wait for the splash screen to disappear
 - Use pyautogui to drive basic GUI flows (load model, slice, export)
 - Collect log output after the run

Requirements:
    pip install pyautogui pywin32 psutil
    (pyautogui needs a display; disable UAC prompts or run elevated.)

Usage:
    python scripts/test_libreslicer_gui.py --exe ..\build\src\libreslicer.exe
"""

import argparse
import os
import subprocess
import sys
import time
from pathlib import Path

try:
    import pyautogui
except ImportError as exc:
    print("pyautogui is required: pip install pyautogui", file=sys.stderr)
    raise

APPDATA_DIR = Path(os.getenv("APPDATA", r"C:\Users\Public\AppData")) / "LibreSlicer"


def launch_libreslicer(exe_path: Path) -> subprocess.Popen:
    if not exe_path.exists():
        raise FileNotFoundError(f"LibreSlicer executable not found: {exe_path}")
    print(f"[INFO] Launching {exe_path}")
    env = os.environ.copy()
    env.setdefault("LIBRESLICER_DISABLE_UPDATE_CHECK", "1")
    proc = subprocess.Popen([str(exe_path)], env=env)
    return proc


def wait_for_main_window(timeout: float = 30.0):
    """Wait for the splash to go away and main window to appear."""
    print("[INFO] Waiting for splash to close…")
    time.sleep(5)  # give splash a moment
    elapsed = 0.0
    while elapsed < timeout:
        # pyautogui.locateOnScreen can detect known UI elements; placeholder for now
        time.sleep(1)
        elapsed += 1
    print("[INFO] Proceeding (timeout reached or assumed main window ready)")


def drive_basic_flow(sample_model: Path):
    """Open a model, slice, export; naive automation using shortcuts."""
    print("[INFO] Driving basic GUI flow…")
    # Open file dialog (Ctrl+O)
    pyautogui.hotkey("ctrl", "o")
    time.sleep(1)
    pyautogui.typewrite(str(sample_model))
    pyautogui.press("enter")
    time.sleep(5)

    # Slice (Ctrl+G)
    pyautogui.hotkey("ctrl", "g")
    time.sleep(10)  # wait for slicing

    # Export (Ctrl+S)
    pyautogui.hotkey("ctrl", "s")
    time.sleep(1)
    pyautogui.typewrite(str(sample_model.with_suffix(".gcode")))
    pyautogui.press("enter")
    time.sleep(2)


def collect_logs(output_dir: Path):
    output_dir.mkdir(parents=True, exist_ok=True)
    log_file = APPDATA_DIR / "print" / "prusa-slicer.log"
    if log_file.exists():
        target = output_dir / "libreslicer.log"
        target.write_text(log_file.read_text(encoding="utf-8"), encoding="utf-8")
        print(f"[INFO] Collected log to {target}")
    else:
        print(f"[WARN] Log file not found at {log_file}")


def main():
    parser = argparse.ArgumentParser(description="LibreSlicer GUI smoke test")
    parser.add_argument("--exe", type=Path, required=True, help="Path to libreslicer.exe")
    parser.add_argument("--model", type=Path, default=Path("resources/data/embossed_text.obj"),
                        help="Sample model to load")
    parser.add_argument("--logdir", type=Path, default=Path("artifacts/gui-test"),
                        help="Where to store collected logs")
    parser.add_argument("--duration", type=float, default=60.0,
                        help="Max seconds to keep LibreSlicer open before terminating")
    args = parser.parse_args()

    proc = launch_libreslicer(args.exe)
    try:
        wait_for_main_window()
        drive_basic_flow(args.model.resolve())
        time.sleep(5)
    finally:
        print("[INFO] Terminating LibreSlicer…")
        proc.terminate()
        try:
            proc.wait(timeout=10)
        except subprocess.TimeoutExpired:
            proc.kill()
    collect_logs(args.logdir.resolve())


if __name__ == "__main__":
    if os.name != "nt":
        print("This automation script is intended for Windows hosts only.", file=sys.stderr)
        sys.exit(1)
    main()
