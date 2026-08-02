#!/usr/bin/env bash
# Mango — dependency checks and install hints

_mango_deps_root() {
  local here
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  printf '%s' "$here"
}

mango_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    *) echo "unknown" ;;
  esac
}

mango_python() {
  local root
  root="$(_mango_deps_root)"
  if [[ -x "$root/.venv/bin/python" ]]; then
    printf '%s' "$root/.venv/bin/python"
  elif command -v python3 &>/dev/null; then
    command -v python3
  else
    return 1
  fi
}

mango_install_hint() {
  local pkg="$1"
  local os
  os="$(mango_os)"
  case "$pkg" in
    ffmpeg)
      case "$os" in
        macos)   echo "brew install ffmpeg" ;;
        linux)   echo "sudo apt install ffmpeg   # or: sudo dnf install ffmpeg" ;;
        windows) echo "winget install Gyan.FFmpeg" ;;
        *)       echo "Install ffmpeg from https://ffmpeg.org/download.html" ;;
      esac
      ;;
    ghostscript)
      case "$os" in
        macos)   echo "brew install ghostscript" ;;
        linux)   echo "sudo apt install ghostscript" ;;
        windows) echo "winget install Artifex.GhostScript" ;;
        *)       echo "Install ghostscript from https://www.ghostscript.com/" ;;
      esac
      ;;
    python)
      case "$os" in
        macos)   echo "brew install python3" ;;
        linux)   echo "sudo apt install python3 python3-venv python3-pip" ;;
        windows) echo "winget install Python.Python.3.12" ;;
        *)       echo "Install Python 3 from https://www.python.org/downloads/" ;;
      esac
      ;;
    venv)
      local root
      root="$(_mango_deps_root)"
      echo "cd $root && ./setup.sh   # or: python3 -m venv .venv && pip install -r requirements.txt"
      ;;
    *)
      echo "pip install $pkg   # inside project venv"
      ;;
  esac
}

require_cmd() {
  local cmd="$1"
  local hint_pkg="${2:-$1}"
  if command -v "$cmd" &>/dev/null; then
    return 0
  fi
  echo "Error: '$cmd' is required but not found." >&2
  echo "Install: $(mango_install_hint "$hint_pkg")" >&2
  return 1
}

require_python() {
  if mango_python &>/dev/null; then
    return 0
  fi
  echo "Error: Python 3 is required but not found." >&2
  echo "Install: $(mango_install_hint python)" >&2
  return 1
}

require_python_pkg() {
  local pkg="$1"
  local py import_name="${2:-$1}"
  require_python || return 1
  py="$(mango_python)"
  if "$py" -c "import ${import_name//-/_}" &>/dev/null 2>&1; then
    return 0
  fi
  # pdf2docx imports as pdf2docx, Pillow as PIL
  if [[ "$import_name" == "pdf2docx" ]] && "$py" -c "import pdf2docx" &>/dev/null; then
    return 0
  fi
  if [[ "$import_name" == "Pillow" ]] && "$py" -c "import PIL" &>/dev/null; then
    return 0
  fi
  if [[ "$import_name" == "pymupdf" ]] && "$py" -c "import fitz" &>/dev/null; then
    return 0
  fi
  echo "Error: Python package '$pkg' is not installed." >&2
  echo "Run: $(mango_install_hint venv)" >&2
  return 1
}

mango_check_python_pkg() {
  local import_name="${1:-}"
  local py
  require_python || return 1
  py="$(mango_python)"
  case "$import_name" in
    Pillow) "$py" -c "import PIL" &>/dev/null ;;
    pymupdf) "$py" -c "import fitz" &>/dev/null ;;
    *) "$py" -c "import ${import_name//-/_}" &>/dev/null ;;
  esac
}
