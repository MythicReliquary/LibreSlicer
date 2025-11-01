#!/usr/bin/env python3
"""Generate a simple black PNG preview.

This is used as a fallback when ImageMagick is unavailable on the CI runner.
"""
from __future__ import annotations

import argparse
import struct
import zlib
from pathlib import Path


def write_png(path: Path, width: int, height: int) -> None:
    def chunk(chunk_type: bytes, data: bytes) -> bytes:
        return (
            struct.pack(">I", len(data))
            + chunk_type
            + data
            + struct.pack(">I", zlib.crc32(chunk_type + data) & 0xFFFFFFFF)
        )

    raw_rows = [b"\x00" + b"\x00\x00\x00" * width for _ in range(height)]
    payload = b"".join(raw_rows)

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("wb") as fh:
        fh.write(b"\x89PNG\r\n\x1a\n")
        fh.write(chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)))
        fh.write(chunk(b"IDAT", zlib.compress(payload, 9)))
        fh.write(chunk(b"IEND", b""))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", type=Path, help="Destination PNG path")
    parser.add_argument("--width", type=int, default=1200)
    parser.add_argument("--height", type=int, default=800)
    args = parser.parse_args(argv)

    write_png(args.path, args.width, args.height)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
