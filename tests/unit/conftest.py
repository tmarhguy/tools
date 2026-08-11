"""Shared fixtures for Mango unit tests."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[2]
BIN = ROOT / "bin"
TOOLS = ROOT / "tools"


@pytest.fixture(scope="session")
def repo_root() -> Path:
    return ROOT


@pytest.fixture(scope="session")
def bin_dir() -> Path:
    return BIN


@pytest.fixture(scope="session")
def python() -> str:
    venv_py = ROOT / ".venv" / "bin" / "python"
    return str(venv_py if venv_py.is_file() else Path(sys.executable))


def run_tool(bin_dir: Path, name: str, *args: str) -> subprocess.CompletedProcess[str]:
    script = bin_dir / name
    return subprocess.run(
        [str(script), *args],
        capture_output=True,
        text=True,
        cwd=bin_dir.parent,
    )
