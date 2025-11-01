#!/usr/bin/env python3
"""Download Siraya Tech calibration STLs declared in manifest.json.

The script is intended for CI preparation. By default it only prints warnings
when a model cannot be retrieved; pass ``--strict`` to turn missing downloads
into fatal errors (useful in self-hosted runners with mirrored assets).
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys
import tempfile
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MANIFEST_DEFAULT = ROOT / "third_party" / "siraya_test_models" / "manifest.json"
TARGET_DIR = ROOT / "third_party" / "siraya_test_models"


def sha256sum(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def download(url: str, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(delete=False) as tmp:
        tmp_path = Path(tmp.name)
    try:
        with urllib.request.urlopen(url) as response, tmp_path.open("wb") as fh:
            fh.write(response.read())
        tmp_path.replace(destination)
    except urllib.error.URLError as exc:  # pragma: no cover - network failure branch
        tmp_path.unlink(missing_ok=True)
        raise RuntimeError(f"failed to download {url}: {exc}")


def ensure_model(model: dict, strict: bool) -> bool:
    filename = model.get("filename")
    if not filename:
        msg = f"Manifest entry {model.get('id', '<unknown>')} is missing 'filename'."
        if strict:
            raise SystemExit(msg)
        print(f"[fetch-siraya] WARNING: {msg}")
        return False

    target = TARGET_DIR / filename
    download_url = model.get("download_url")
    expected_sha = model.get("sha256")

    if target.exists():
        if expected_sha:
            actual_sha = sha256sum(target)
            if actual_sha.lower() != expected_sha.lower():
                msg = (
                    f"hash mismatch for {filename}: expected {expected_sha}, got {actual_sha}."
                )
                if strict:
                    raise SystemExit(msg)
                print(f"[fetch-siraya] WARNING: {msg}")
                return False
        return True

    if not download_url:
        msg = (
            f"no download_url for {filename}; place the STL manually in {TARGET_DIR}"
        )
        if strict:
            raise SystemExit(msg)
        print(f"[fetch-siraya] WARNING: {msg}")
        return False

    try:
        print(f"[fetch-siraya] Downloading {filename} from {download_url}")
        download(download_url, target)
    except RuntimeError as exc:
        if strict:
            raise SystemExit(str(exc))
        print(f"[fetch-siraya] WARNING: {exc}")
        return False

    if expected_sha:
        actual_sha = sha256sum(target)
        if actual_sha.lower() != expected_sha.lower():
            msg = (
                f"hash mismatch for {filename} after download: expected {expected_sha}, got {actual_sha}."
            )
            if strict:
                raise SystemExit(msg)
            print(f"[fetch-siraya] WARNING: {msg}")
            return False

    return True


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manifest",
        type=Path,
        default=MANIFEST_DEFAULT,
        help="Path to manifest.json (default: %(default)s)",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Fail if any model is missing or cannot be downloaded.",
    )
    args = parser.parse_args(argv)

    manifest_path = args.manifest
    if not manifest_path.exists():
        parser.error(f"manifest not found: {manifest_path}")

    with manifest_path.open("r", encoding="utf-8") as fh:
        manifest = json.load(fh)

    models = manifest.get("models", [])
    if not models:
        print("[fetch-siraya] No models declared in manifest.")
        return 0

    success = True
    for model in models:
        success = ensure_model(model, strict=args.strict) and success

    return 0 if success or not args.strict else 1


if __name__ == "__main__":
    sys.exit(main())
