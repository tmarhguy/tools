#!/usr/bin/env python3
"""Pretty-print or minify JSON."""

import argparse
import json
import os
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description="Format or minify JSON.")
    parser.add_argument("input", help="Input JSON file")
    parser.add_argument("-o", "--output", help="Output file (default: stdout)")
    parser.add_argument("-m", "--minify", action="store_true", help="Minify instead of pretty-print")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    with open(args.input, encoding="utf-8") as fh:
        data = json.load(fh)

    if args.minify:
        text = json.dumps(data, separators=(",", ":"), ensure_ascii=False)
    else:
        text = json.dumps(data, indent=2, ensure_ascii=False) + "\n"

    if args.output:
        os.makedirs(os.path.dirname(os.path.abspath(args.output)) or ".", exist_ok=True)
        with open(args.output, "w", encoding="utf-8") as fh:
            fh.write(text)
        print(f"Saved: {args.output}")
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
