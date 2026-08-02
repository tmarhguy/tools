#!/usr/bin/env bash
# Mango UI — shared terminal UI components

# Colors & styles
MANGO_BOLD=$'\e[1m'
MANGO_DIM=$'\e[2m'
MANGO_RESET=$'\e[0m'
MANGO_CYAN=$'\e[1;36m'
MANGO_YELLOW=$'\e[1;33m'
MANGO_GREEN=$'\e[1;32m'
MANGO_RED=$'\e[1;31m'
MANGO_MAGENTA=$'\e[1;35m'
MANGO_WHITE=$'\e[1;37m'
MANGO_BG_DARK=$'\e[48;5;235m'
MANGO_FG_MANGO=$'\e[38;5;214m'   # golden mango (distinct from Claude's rust orange)

MANGO_UI_WIDTH="${COLUMNS:-80}"
if [[ "$MANGO_UI_WIDTH" -lt 60 ]]; then
  MANGO_UI_WIDTH=60
elif [[ "$MANGO_UI_WIDTH" -gt 100 ]]; then
  MANGO_UI_WIDTH=100
fi
MANGO_UI_INNER=$((MANGO_UI_WIDTH - 4))
MANGO_ALT_SCREEN=0

_mango_repeat() {
  local char="$1" count="$2" i
  for ((i = 0; i < count; i++)); do printf '%s' "$char"; done
}

_mango_pad_center() {
  local text="$1" width="$2"
  local len=${#text}
  local pad=$(( (width - len) / 2 ))
  printf '%*s%s%*s' "$pad" '' "$text" "$((width - len - pad))" ''
}

_mango_strip_ansi() {
  sed 's/\x1b\[[0-9;]*m//g'
}

ui_enter_alt_screen() {
  [[ -t 1 ]] || return 0
  [[ "${MANGO_NO_ALT_SCREEN:-0}" -eq 1 ]] && return 0
  printf '\033[?1049h\033[H'
  MANGO_ALT_SCREEN=1
}

ui_leave_alt_screen() {
  [[ "${MANGO_ALT_SCREEN:-0}" -eq 1 ]] || return 0
  printf '\033[?1049l'
  MANGO_ALT_SCREEN=0
}

ui_clear() {
  if [[ -t 1 ]]; then
    # Avoid spawning `clear` — home + erase is much faster
    printf '\033[H\033[2J'
  fi
}

ui_logo() {
  # Claude-style sparkle mascot (layout only — color is Mango gold, not Claude orange)
  echo -e "${MANGO_FG_MANGO}${MANGO_BOLD} ▐▛███▜▌${MANGO_RESET}"
  echo -e "${MANGO_FG_MANGO}${MANGO_BOLD}▝▜█████▛▘${MANGO_RESET}"
  echo -e "${MANGO_FG_MANGO}${MANGO_BOLD}  ▘▘ ▝▝${MANGO_RESET}"
}

_ui_brand_lines() {
  ui_box_line "${MANGO_FG_MANGO}${MANGO_BOLD} ▐▛███▜▌${MANGO_RESET}   ${MANGO_WHITE}${MANGO_BOLD}Mango${MANGO_RESET}  ${MANGO_DIM}v1.0${MANGO_RESET}"
  ui_box_line "${MANGO_FG_MANGO}${MANGO_BOLD}▝▜█████▛▘${MANGO_RESET}  ${MANGO_DIM}My Toolkit Hub${MANGO_RESET}"
  ui_box_line "${MANGO_FG_MANGO}${MANGO_BOLD}  ▘▘ ▝▝${MANGO_RESET}    ${MANGO_DIM}offline · private · fast${MANGO_RESET}"
}

ui_header() {
  ui_clear
  echo ""
  ui_box_open
  _ui_brand_lines
  ui_box_close
  echo ""
}

ui_home_panel() {
  ui_clear
  echo ""
  ui_box_open
  _ui_brand_lines
  ui_box_rule
  ui_box_line "  ${MANGO_DIM}You are here:${MANGO_RESET} ${MANGO_FG_MANGO}${MANGO_BOLD}Home${MANGO_RESET}"
  ui_box_rule
  ui_box_line "  ${MANGO_WHITE}Use favorite tools from terminal.${MANGO_RESET}"
  ui_box_line "  ${MANGO_DIM}Pick a file and let Mango guide you.${MANGO_RESET}"
  ui_box_close
  echo ""
}

ui_title_bar() {
  local title="$1"
  local inner=$MANGO_UI_INNER
  local line
  line=$(_mango_pad_center " $title " "$inner")

  echo ""
  echo -e "${MANGO_FG_MANGO}╔$(_mango_repeat '═' "$inner")╗${MANGO_RESET}"
  echo -e "${MANGO_FG_MANGO}║${MANGO_RESET}${MANGO_YELLOW}${MANGO_BOLD}${line}${MANGO_RESET}${MANGO_FG_MANGO}║${MANGO_RESET}"
  echo -e "${MANGO_FG_MANGO}╚$(_mango_repeat '═' "$inner")╝${MANGO_RESET}"
  echo ""
}

ui_box_open() {
  local title="${1:-}"
  local inner=$MANGO_UI_INNER

  echo -e "${MANGO_FG_MANGO}┌$(_mango_repeat '─' "$inner")┐${MANGO_RESET}"
  if [[ -n "$title" ]]; then
    local label=" $title "
    local pad=$((inner - ${#label}))
    echo -e "${MANGO_FG_MANGO}│${MANGO_RESET}${MANGO_YELLOW}${MANGO_BOLD}${label}${MANGO_RESET}$(_mango_repeat ' ' "$pad")${MANGO_FG_MANGO}│${MANGO_RESET}"
    echo -e "${MANGO_FG_MANGO}├$(_mango_repeat '─' "$inner")┤${MANGO_RESET}"
  fi
}

ui_box_line() {
  local text="$1"
  local inner=$MANGO_UI_INNER
  local plain
  plain=$(printf '%b' "$text" | _mango_strip_ansi)
  local pad=$((inner - 2 - ${#plain}))
  if [[ "$pad" -lt 0 ]]; then pad=0; fi
  echo -e "${MANGO_FG_MANGO}│${MANGO_RESET} ${text}$(_mango_repeat ' ' "$pad") ${MANGO_FG_MANGO}│${MANGO_RESET}"
}

ui_box_close() {
  local inner=$MANGO_UI_INNER
  echo -e "${MANGO_FG_MANGO}└$(_mango_repeat '─' "$inner")┘${MANGO_RESET}"
}

ui_box_rule() {
  local inner=$MANGO_UI_INNER
  echo -e "${MANGO_FG_MANGO}├$(_mango_repeat '─' "$inner")┤${MANGO_RESET}"
}

ui_divider() {
  local inner=$MANGO_UI_INNER
  echo -e "${MANGO_DIM}$(_mango_repeat '─' "$inner")${MANGO_RESET}"
}

ui_menu() {
  local -a labels=()
  local -a descs=()
  local i=0

  while [[ $# -gt 0 ]]; do
    labels+=("$1")
    shift
    if [[ $# -gt 0 && "$1" != --* ]]; then
      descs+=("$1")
      shift
    else
      descs+=("")
    fi
  done

  ui_box_open "Main Menu"

  for i in "${!labels[@]}"; do
    local num=$((i + 1))
    local label="${labels[$i]}"
    local desc="${descs[$i]:-}"

    if [[ "$(printf '%s' "$label" | tr '[:upper:]' '[:lower:]')" == "exit" ]]; then
      ui_box_line "  ${MANGO_RED}${MANGO_BOLD}${num})${MANGO_RESET} ${MANGO_RED}${label}${MANGO_RESET}"
    else
      ui_box_line "  ${MANGO_GREEN}${MANGO_BOLD}${num})${MANGO_RESET} ${MANGO_WHITE}${label}${MANGO_RESET}  ${MANGO_DIM}${desc}${MANGO_RESET}"
    fi
  done

  ui_box_close
  echo ""
}

ui_footer() {
  local text="${1-}"
  if [[ -z "$text" ]]; then
    text="Mango · My Toolkit Hub"
  fi
  echo ""
  echo -e "${MANGO_FG_MANGO}$(_mango_repeat '─' "$MANGO_UI_WIDTH")${MANGO_RESET}"
  echo -e "${MANGO_DIM}"
  _mango_pad_center "$text" "$MANGO_UI_WIDTH"
  echo -e "${MANGO_RESET}"
}

ui_prompt() {
  local message="$1"
  local varname="$2"

  ui_box_open
  ui_box_line "${MANGO_CYAN}${MANGO_BOLD}❯${MANGO_RESET} ${message}"
  ui_box_close
  echo -ne "  ${MANGO_CYAN}❯${MANGO_RESET} "
  read -er "$varname"
}

ui_prompt_secret() {
  local message="$1"
  local varname="$2"

  ui_box_open
  ui_box_line "${MANGO_CYAN}${MANGO_BOLD}❯${MANGO_RESET} ${message}"
  ui_box_line "  ${MANGO_DIM}(input hidden)${MANGO_RESET}"
  ui_box_close
  echo -ne "  ${MANGO_CYAN}❯${MANGO_RESET} "
  read -rs "$varname"
  echo ""
}

ui_message() {
  local level="$1"
  local text="$2"
  local icon color

  case "$level" in
    success) icon="✔"; color="$MANGO_GREEN" ;;
    error)   icon="✖"; color="$MANGO_RED" ;;
    warning) icon="⚠"; color="$MANGO_YELLOW" ;;
    info)    icon="ℹ"; color="$MANGO_CYAN" ;;
    *)       icon="·"; color="$MANGO_WHITE" ;;
  esac

  ui_box_open
  ui_box_line "  ${color}${MANGO_BOLD}${icon}${MANGO_RESET}  ${text}"
  ui_box_close
}

ui_tool_header() {
  local name="$1"
  local category="$2"
  ui_clear
  ui_header
  ui_title_bar "$name"
  if [[ -n "$category" ]]; then
    echo -e "  ${MANGO_DIM}Category:${MANGO_RESET} ${MANGO_MAGENTA}${category}${MANGO_RESET}"
    echo ""
  fi
}

ui_pause() {
  local msg="${1:-Press Enter to return to the menu...}"
  echo ""
  ui_prompt "$msg" _MANGO_DUMMY
}

ui_run_tool() {
  local name="$1"
  shift
  echo ""
  ui_box_open "Running"
  ui_box_line "  ${MANGO_DIM}Executing:${MANGO_RESET} ${MANGO_WHITE}${MANGO_BOLD}${name}${MANGO_RESET}"
  ui_box_close
  echo ""
  echo -e "${MANGO_DIM}$(_mango_repeat '─' $((MANGO_UI_WIDTH - 4)))${MANGO_RESET}"
  echo ""

  if "$@"; then
    echo ""
    echo -e "${MANGO_DIM}$(_mango_repeat '─' $((MANGO_UI_WIDTH - 4)))${MANGO_RESET}"
    ui_message success "Done! ${name} completed successfully."
  else
    local code=$?
    echo ""
    echo -e "${MANGO_DIM}$(_mango_repeat '─' $((MANGO_UI_WIDTH - 4)))${MANGO_RESET}"
    ui_message error "${name} failed (exit code ${code})."
    return "$code"
  fi
}

ui_breadcrumb() {
  local -a crumbs=("$@")
  local trail="" i

  for i in "${!crumbs[@]}"; do
    if [[ -n "$trail" ]]; then
      trail+=" ${MANGO_DIM}›${MANGO_RESET} "
    fi
    if [[ "$i" -eq $((${#crumbs[@]} - 1)) ]]; then
      trail+="${MANGO_FG_MANGO}${MANGO_BOLD}${crumbs[$i]}${MANGO_RESET}"
    else
      trail+="${MANGO_DIM}${crumbs[$i]}${MANGO_RESET}"
    fi
  done

  echo -e "  ${MANGO_DIM}You are here:${MANGO_RESET} ${trail}"
  echo ""
}

ui_prompt_default() {
  local message="$1"
  local default="$2"
  local varname="$3"

  ui_box_open
  ui_box_line "${MANGO_CYAN}${MANGO_BOLD}❯${MANGO_RESET} ${message}"
  ui_box_line "  ${MANGO_DIM}(Enter = ${default})${MANGO_RESET}"
  ui_box_close
  echo -ne "  ${MANGO_CYAN}❯${MANGO_RESET} "
  local input
  read -er input
  if [[ -z "$input" ]]; then
    printf -v "$varname" '%s' "$default"
  else
    printf -v "$varname" '%s' "$input"
  fi
}

_mango_file_size() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "—"
    return
  fi
  if stat -f%z "$path" &>/dev/null; then
    local bytes
    bytes=$(stat -f%z "$path")
    if [[ "$bytes" -ge 1073741824 ]]; then
      awk -v b="$bytes" 'BEGIN { printf "%.1f GB", b/1073741824 }'
    elif [[ "$bytes" -ge 1048576 ]]; then
      awk -v b="$bytes" 'BEGIN { printf "%.1f MB", b/1048576 }'
    elif [[ "$bytes" -ge 1024 ]]; then
      awk -v b="$bytes" 'BEGIN { printf "%.1f KB", b/1024 }'
    else
      echo "${bytes} B"
    fi
  else
    ls -lh "$path" 2>/dev/null | awk '{print $5}'
  fi
}

_mango_expand_path() {
  local path="$1"
  path="${path/#\~/$HOME}"
  if [[ "$path" != /* ]]; then
    path="$(pwd)/$path"
  fi
  # Resolve . and .. without requiring realpath
  if command -v python3 &>/dev/null; then
    python3 -c 'import os,sys; print(os.path.abspath(sys.argv[1]))' "$path" 2>/dev/null && return
  fi
  echo "$path"
}

ui_list_matching_files() {
  local -a exts=("$@")
  local -a found=()
  local f ext pattern

  shopt -s nullglob
  for ext in "${exts[@]}"; do
    pattern="*.${ext}"
    for f in $pattern; do
      [[ -f "$f" ]] && found+=("$f")
    done
  done
  shopt -u nullglob

  if [[ ${#found[@]} -eq 0 ]]; then
    return 1
  fi

  ui_box_open "Files in $(pwd)"
  local i=1
  for f in "${found[@]}"; do
    local size
    size=$(_mango_file_size "$f")
    ui_box_line "  ${MANGO_DIM}${i})${MANGO_RESET} ${MANGO_WHITE}${f}${MANGO_RESET}  ${MANGO_DIM}${size}${MANGO_RESET}"
    ((i++)) || true
  done
  ui_box_close
  echo ""
  return 0
}

ui_prompt_file() {
  local message="$1"
  local varname="$2"
  shift 2
  local -a allowed_exts=("$@")

  while true; do
    if [[ ${#allowed_exts[@]} -gt 0 ]]; then
      ui_list_matching_files "${allowed_exts[@]}" || true
    fi

    ui_prompt "$message" _MANGO_FILE_INPUT
    local raw="$_MANGO_FILE_INPUT"
    [[ -z "$raw" ]] && continue

    local path
    path=$(_mango_expand_path "$raw")

    if [[ ! -e "$path" ]]; then
      ui_message error "File not found: ${raw}"
      echo ""
      continue
    fi
    if [[ ! -f "$path" ]]; then
      ui_message error "Not a regular file: ${raw}"
      echo ""
      continue
    fi

    if [[ ${#allowed_exts[@]} -gt 0 ]]; then
      local ext="${path##*.}"
      ext=$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')
      local ok=0 allowed
      for allowed in "${allowed_exts[@]}"; do
        if [[ "$ext" == "$(printf '%s' "$allowed" | tr '[:upper:]' '[:lower:]')" ]]; then
          ok=1
          break
        fi
      done
      if [[ "$ok" -eq 0 ]]; then
        local joined
        joined=$(IFS=', '; echo "${allowed_exts[*]}")
        ui_message warning "Expected one of: ${joined}  (got .${ext})"
        echo ""
        continue
      fi
    fi

    printf -v "$varname" '%s' "$path"
    return 0
  done
}

ui_conversion_preview() {
  local input="$1"
  local output="$2"
  local label="${3:-Conversion}"

  local in_base out_base in_ext out_ext
  in_base=$(basename "$input")
  out_base=$(basename "$output")
  in_ext="${in_base##*.}"
  out_ext="${out_base##*.}"
  local in_size
  in_size=$(_mango_file_size "$input")

  ui_box_open "$label"
  ui_box_line "  ${MANGO_DIM}From:${MANGO_RESET}  ${MANGO_WHITE}${in_base}${MANGO_RESET}  ${MANGO_DIM}${in_size}${MANGO_RESET}"
  ui_box_line "  ${MANGO_DIM}       ${MANGO_FG_MANGO}↓${MANGO_RESET}"
  ui_box_line "  ${MANGO_DIM}To:${MANGO_RESET}    ${MANGO_GREEN}${out_base}${MANGO_RESET}  ${MANGO_DIM}.${out_ext}${MANGO_RESET}"
  ui_box_close
  echo ""
}

ui_confirm() {
  local message="${1:-Proceed?}"
  local varname="${2:-_MANGO_CONFIRM}"
  echo -ne "  ${MANGO_YELLOW}?${MANGO_RESET} ${message} ${MANGO_DIM}[y/N]${MANGO_RESET} "
  local answer
  read -r answer
  case "$(printf '%s' "$answer" | tr '[:upper:]' '[:lower:]')" in
    y|yes) printf -v "$varname" '%s' "yes"; return 0 ;;
    *) printf -v "$varname" '%s' "no"; return 1 ;;
  esac
}

ui_menu_numbered() {
  local title="$1"
  shift
  local -a items=("$@")

  ui_box_open "$title"
  local i=1
  for item in "${items[@]}"; do
    local label status icon color
    label="${item%%|*}"
    status="${item#*|}"

    if [[ "$status" == "ready" ]]; then
      icon="●"
      color="$MANGO_GREEN"
    elif [[ "$status" == "soon" ]]; then
      icon="○"
      color="$MANGO_DIM"
    else
      icon="·"
      color="$MANGO_WHITE"
    fi

    if [[ "$(printf '%s' "$label" | tr '[:upper:]' '[:lower:]')" == "back" ]]; then
      ui_box_line "  ${MANGO_DIM}${i})${MANGO_RESET} ${MANGO_DIM}← ${label}${MANGO_RESET}"
    elif [[ "$(printf '%s' "$label" | tr '[:upper:]' '[:lower:]')" == "exit" ]]; then
      ui_box_line "  ${MANGO_RED}${MANGO_BOLD}${i})${MANGO_RESET} ${MANGO_RED}${label}${MANGO_RESET}"
    else
      ui_box_line "  ${color}${icon}${MANGO_RESET}  ${MANGO_GREEN}${MANGO_BOLD}${i})${MANGO_RESET} ${color}${label}${MANGO_RESET}"
    fi
    ((i++)) || true
  done
  ui_box_close
  echo ""
}

ui_suggest_output() {
  local input="$1"
  local new_ext="$2"
  local dir base
  dir=$(dirname "$input")
  base=$(basename "$input")
  base="${base%.*}"
  echo "${dir}/${base}.${new_ext}"
}

ui_suggest_output_dir() {
  local input="$1"
  local suffix="${2:-_out}"
  local dir base
  dir=$(dirname "$input")
  base=$(basename "$input")
  base="${base%.*}"
  echo "${dir}/${base}${suffix}"
}
