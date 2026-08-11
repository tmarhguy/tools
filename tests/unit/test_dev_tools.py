"""Unit tests for developer CLI tools."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import pytest

from conftest import run_tool


def test_format_json_pretty(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "in.json"
    out = tmp_path / "out.json"
    inp.write_text('{"hello":"world","n":1}', encoding="utf-8")

    result = run_tool(bin_dir, "format-json", str(inp), "-o", str(out))
    assert result.returncode == 0, result.stderr
    data = json.loads(out.read_text(encoding="utf-8"))
    assert data == {"hello": "world", "n": 1}
    assert "\n" in out.read_text(encoding="utf-8")


def test_format_json_minify(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "in.json"
    out = tmp_path / "min.json"
    inp.write_text('{"a": 1, "b": 2}', encoding="utf-8")

    result = run_tool(bin_dir, "format-json", str(inp), "-o", str(out), "-m")
    assert result.returncode == 0, result.stderr
    assert out.read_text(encoding="utf-8") == '{"a":1,"b":2}'


def test_format_json_missing_file(bin_dir: Path, tmp_path: Path) -> None:
    result = run_tool(bin_dir, "format-json", str(tmp_path / "nope.json"))
    assert result.returncode != 0


def test_csv_to_json(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "data.csv"
    out = tmp_path / "data.json"
    inp.write_text("name,value\nfoo,1\nbar,2\n", encoding="utf-8")

    result = run_tool(bin_dir, "csv-to-json", str(inp), "-o", str(out))
    assert result.returncode == 0, result.stderr
    rows = json.loads(out.read_text(encoding="utf-8"))
    assert rows == [{"name": "foo", "value": "1"}, {"name": "bar", "value": "2"}]


def test_hash_gen_default(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "file.bin"
    payload = b"mango-test-payload"
    inp.write_bytes(payload)
    expected = hashlib.sha256(payload).hexdigest()

    result = run_tool(bin_dir, "hash-gen", str(inp))
    assert result.returncode == 0, result.stderr
    assert expected in result.stdout


@pytest.mark.parametrize("algo", ["md5", "sha1", "sha256"])
def test_hash_gen_algorithms(bin_dir: Path, tmp_path: Path, algo: str) -> None:
    inp = tmp_path / "file.bin"
    inp.write_bytes(b"test")

    result = run_tool(bin_dir, "hash-gen", str(inp), "-a", algo)
    assert result.returncode == 0, result.stderr
    assert algo.upper() in result.stdout


def test_base64_roundtrip(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "plain.txt"
    enc = tmp_path / "encoded.b64"
    dec = tmp_path / "decoded.txt"
    inp.write_text("hello mango", encoding="utf-8")

    enc_result = run_tool(bin_dir, "base64-tool", str(inp), "-o", str(enc))
    assert enc_result.returncode == 0, enc_result.stderr

    dec_result = run_tool(bin_dir, "base64-tool", str(enc), "-o", str(dec), "--decode")
    assert dec_result.returncode == 0, dec_result.stderr
    assert dec.read_text(encoding="utf-8") == inp.read_text(encoding="utf-8")
