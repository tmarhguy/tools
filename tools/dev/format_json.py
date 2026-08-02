#!/usr/bin/env python3
"""Pretty-print or minify JSON files."""
import argparse
import json
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description="Format JSON files")
    parser.add_argument("input", help="Input JSON file")
    parser.add_argument("-o", "--output", help="Output file (default: stdout)")
    parser.add_argument("-m", "--minify", action="store_true", help="Minify output")
    args = parser.parse_args()

    with open(args.input, encoding="utf-8") as f:
        data = json.load(f)

    if args.minify:
        text = json.dumps(data, separators=(",", ":"), ensure_ascii=False)
    else:
        text = json.dumps(data, indent=2, ensure_ascii=False) + "\n"

    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(text)
        print(f"Wrote {args.output}")
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
