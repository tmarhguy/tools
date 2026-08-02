#!/usr/bin/env bash
# Mango setup — local venv, Python deps, optional ffmpeg, PATH symlink
#
# From a clone:
#   ./setup.sh
#
# One-liner (installs to ~/.local/share/mango):
#   curl -fsSL https://raw.githubusercontent.com/tmarhguy/tools/main/setup.sh | bash
#
# Options:
#   -y, --yes          Non-interactive (yes to prompts)
#   --no-ffmpeg        Skip ffmpeg install attempt
#   --no-link          Skip ~/.local/bin symlink
#   --link             Always symlink mango to ~/.local/bin

set -euo pipefail

MANGO_REPO_URL="${MANGO_REPO_URL:-https://github.com/tmarhguy/tools.git}"
MANGO_INSTALL_DIR="${MANGO_INSTALL_DIR:-$HOME/.local/share/mango}"
MANGO_BIN_DIR="${MANGO_BIN_DIR:-$HOME/.local/bin}"
MANGO_BRANCH="${MANGO_BRANCH:-main}"

ASSUME_YES=0
SKIP_FFMPEG=0
SKIP_LINK=0
FORCE_LINK=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes) ASSUME_YES=1; shift ;;
    --no-ffmpeg) SKIP_FFMPEG=1; shift ;;
    --no-link) SKIP_LINK=1; shift ;;
    --link) FORCE_LINK=1; shift ;;
    -h|--help)
      sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

_mango_step() { echo ""; echo "==> $*"; }
_mango_info()  { echo "    $*"; }

_mango_confirm() {
  local prompt="$1"
  [[ "$ASSUME_YES" -eq 1 ]] && return 0
  printf '%s [y/N] ' "$prompt"
  local ans
  read -r ans
  case "$(printf '%s' "$ans" | tr '[:upper:]' '[:lower:]')" in
    y|yes) return 0 ;;
    *) return 1 ;;
  esac
}

_mango_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    *) echo "unknown" ;;
  esac
}

_mango_resolve_root() {
  local script_dir=""
  if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "bash" && "${BASH_SOURCE[0]}" != "-" ]]; then
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" 2>/dev/null || true
  fi

  if [[ -n "$script_dir" && -f "$script_dir/requirements.txt" && -f "$script_dir/mango" ]]; then
    printf '%s' "$script_dir"
    return 0
  fi

  if [[ -f "./requirements.txt" && -f "./mango" ]]; then
    pwd
    return 0
  fi

  # Remote / curl install — use fixed install dir
  local dir="$MANGO_INSTALL_DIR"
  if [[ -d "$dir/.git" && -f "$dir/requirements.txt" ]]; then
    _mango_step "Updating existing install at $dir"
    git -C "$dir" pull --ff-only origin "$MANGO_BRANCH" 2>/dev/null || git -C "$dir" pull --ff-only 2>/dev/null || true
    printf '%s' "$dir"
    return 0
  fi

  if [[ ! -d "$dir" ]]; then
    _mango_step "Cloning Mango to $dir"
    command -v git &>/dev/null || { echo "Error: git is required for remote install." >&2; exit 1; }
    git clone --depth 1 --branch "$MANGO_BRANCH" "$MANGO_REPO_URL" "$dir"
  fi

  printf '%s' "$dir"
}

_mango_check_python() {
  if ! command -v python3 &>/dev/null; then
    echo "Error: python3 not found. Install Python 3.9+ first." >&2
    case "$(_mango_os)" in
      macos)   echo "  brew install python3" >&2 ;;
      linux)   echo "  sudo apt install python3 python3-venv python3-pip" >&2 ;;
      windows) echo "  winget install Python.Python.3.12" >&2 ;;
    esac
    exit 1
  fi
  local ver
  ver="$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')"
  _mango_info "Python $ver"
}

_mango_setup_venv() {
  local root="$1"
  cd "$root"

  if [[ ! -d .venv ]]; then
    _mango_step "Creating virtual environment"
    python3 -m venv .venv
  else
    _mango_info "Virtual env already exists"
  fi

  _mango_step "Installing Python packages"
  # shellcheck disable=SC1091
  source .venv/bin/activate
  python -m pip install --upgrade pip -q
  pip install -r requirements.txt -q
  _mango_info "Done (Pillow, pypdf, pdf2docx, pymupdf)"
}

_mango_chmod_scripts() {
  local root="$1"
  _mango_step "Making scripts executable"
  chmod +x "$root/mango" "$root/bin/"* 2>/dev/null || true
  find "$root/tools" -name '*.sh' -exec chmod +x {} + 2>/dev/null || true
}

_mango_try_ffmpeg() {
  [[ "$SKIP_FFMPEG" -eq 1 ]] && return 0
  command -v ffmpeg &>/dev/null && { _mango_info "ffmpeg already installed"; return 0; }

  _mango_step "ffmpeg not found (needed for video tools)"
  case "$(_mango_os)" in
    macos)
      if command -v brew &>/dev/null; then
        _mango_confirm "Install ffmpeg with Homebrew?" && brew install ffmpeg
      else
        _mango_info "Install manually: brew install ffmpeg"
      fi
      ;;
    linux)
      if command -v apt-get &>/dev/null; then
        _mango_confirm "Install ffmpeg with apt?" && sudo apt-get install -y ffmpeg
      elif command -v dnf &>/dev/null; then
        _mango_confirm "Install ffmpeg with dnf?" && sudo dnf install -y ffmpeg
      else
        _mango_info "Install ffmpeg with your package manager"
      fi
      ;;
    windows)
      if command -v winget &>/dev/null; then
        _mango_confirm "Install ffmpeg with winget?" && winget install Gyan.FFmpeg
      else
        _mango_info "Install manually: winget install Gyan.FFmpeg"
      fi
      ;;
    *)
      _mango_info "See https://ffmpeg.org/download.html"
      ;;
  esac
}

_mango_link_bin() {
  local root="$1"
  [[ "$SKIP_LINK" -eq 1 && "$FORCE_LINK" -eq 0 ]] && return 0

  local link_mango=0
  if [[ "$FORCE_LINK" -eq 1 ]]; then
    link_mango=1
  elif _mango_confirm "Symlink mango → $MANGO_BIN_DIR/mango?"; then
    link_mango=1
  fi

  [[ "$link_mango" -eq 1 ]] || return 0

  mkdir -p "$MANGO_BIN_DIR"
  ln -sf "$root/mango" "$MANGO_BIN_DIR/mango"
  _mango_info "Linked: $MANGO_BIN_DIR/mango"

  case ":$PATH:" in
    *":$MANGO_BIN_DIR:"*) ;;
    *)
      _mango_info "Add to PATH: export PATH=\"\$PATH:$MANGO_BIN_DIR\""
      ;;
  esac
}

main() {
  echo ""
  echo "Mango Setup"
  echo "───────────"

  _mango_check_python
  local root
  root="$(_mango_resolve_root)"
  _mango_info "Install directory: $root"

  _mango_setup_venv "$root"
  _mango_chmod_scripts "$root"
  _mango_try_ffmpeg

  _mango_step "Running mango doctor"
  "$root/bin/mango-doctor" || true

  _mango_link_bin "$root"

  echo ""
  echo "Setup complete."
  echo ""
  echo "  cd $root && ./mango          # interactive UI"
  echo "  $root/bin/to_gif --help      # run a tool directly"
  echo ""
  if [[ "$root" == "$MANGO_INSTALL_DIR" ]]; then
    echo "  Installed to $MANGO_INSTALL_DIR (offline after setup)"
    [[ -x "$MANGO_BIN_DIR/mango" ]] && echo "  Or run: mango"
  fi
  echo ""
}

main "$@"
