#!/usr/bin/env python3
"""Generate file checksums."""

import argparse
import hashlib
import os
import sys


def digest(path: str, algo: str) -> str:
    h = hashlib.new(algo)
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description="Hash a file.")
    parser.add_argument("input", help="Input file path")
    parser.add_argument("-a", "--algorithm", default="sha256",
                        choices=("md5", "sha1", "sha256"), help="Hash algorithm")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    value = digest(args.input, args.algorithm)
    print(f"{args.algorithm.upper()}: {value}")
    print(f"File:  {args.input}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
