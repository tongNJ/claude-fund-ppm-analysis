#!/usr/bin/env bash
#
# install.sh — symlink claude-fund-research components into ~/.claude/
#
# Usage:
#   ./install.sh             # install (create symlinks)
#   ./install.sh --uninstall # remove symlinks (does not delete the repo)
#

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

# ANSI colors for friendlier output (degrades silently in dumb terminals)
if [[ -t 1 ]]; then
  GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RED=$'\033[31m'; RESET=$'\033[0m'
else
  GREEN=""; YELLOW=""; RED=""; RESET=""
fi

info()  { echo "${GREEN}✓${RESET} $*"; }
warn()  { echo "${YELLOW}!${RESET} $*"; }
error() { echo "${RED}✗${RESET} $*" >&2; }

UNINSTALL=0
if [[ "${1:-}" == "--uninstall" ]]; then
  UNINSTALL=1
fi

# Skills, sub-agents, and commands to manage. Format: <source-relative-to-repo>:<dest-relative-to-~/.claude>
TARGETS=(
  "skills/analyzing-fund-ppm:skills/analyzing-fund-ppm"
  "sub-agents/ppm-extractor/ppm-extractor.md:agents/ppm-extractor.md"
  "commands/process-ppms.md:commands/process-ppms.md"
)

# --- uninstall path ---------------------------------------------------------
if [[ "${UNINSTALL}" -eq 1 ]]; then
  echo "Uninstalling claude-fund-research symlinks from ${CLAUDE_DIR}..."
  for entry in "${TARGETS[@]}"; do
    dest_rel="${entry##*:}"
    dest="${CLAUDE_DIR}/${dest_rel}"
    if [[ -L "${dest}" ]]; then
      rm "${dest}"
      info "Removed symlink: ${dest}"
    elif [[ -e "${dest}" ]]; then
      warn "Not a symlink, skipping: ${dest}"
    else
      warn "Already absent: ${dest}"
    fi
  done
  echo
  info "Uninstall complete. Repo at ${REPO_DIR} is untouched."
  exit 0
fi

# --- install path -----------------------------------------------------------
echo "Installing claude-fund-research from ${REPO_DIR} into ${CLAUDE_DIR}..."
echo

# Refuse to install if the SKILL.md is still the stub
SKILL_FILE="${REPO_DIR}/skills/analyzing-fund-ppm/SKILL.md"
if grep -q "STUB FILE — REPLACE ME" "${SKILL_FILE}" 2>/dev/null; then
  error "skills/analyzing-fund-ppm/SKILL.md is still the stub placeholder."
  error "Copy your real SKILL.md into place before installing:"
  error "  cp ~/.claude/skills/analyzing-fund-ppm/SKILL.md ${SKILL_FILE}"
  error "See skills/analyzing-fund-ppm/README.md for the full checklist."
  exit 1
fi

# Make sure ~/.claude/ subfolders exist
mkdir -p "${CLAUDE_DIR}/skills" "${CLAUDE_DIR}/agents" "${CLAUDE_DIR}/commands"

for entry in "${TARGETS[@]}"; do
  src_rel="${entry%%:*}"
  dest_rel="${entry##*:}"
  src="${REPO_DIR}/${src_rel}"
  dest="${CLAUDE_DIR}/${dest_rel}"

  if [[ ! -e "${src}" ]]; then
    error "Source missing: ${src}"
    exit 1
  fi

  # If destination exists and is not the symlink we'd create, back it up.
  if [[ -e "${dest}" || -L "${dest}" ]]; then
    if [[ -L "${dest}" && "$(readlink "${dest}")" == "${src}" ]]; then
      info "Already linked: ${dest}"
      continue
    fi
    backup="${dest}.backup-$(date +%Y%m%d-%H%M%S)"
    mv "${dest}" "${backup}"
    warn "Backed up existing ${dest} to ${backup}"
  fi

  # Make sure parent directory of dest exists
  mkdir -p "$(dirname "${dest}")"

  ln -s "${src}" "${dest}"
  info "Linked ${dest} → ${src}"
done

echo
info "Install complete."
echo
echo "Next steps:"
echo "  1. Configure permissions so batch runs don't prompt every minute:"
echo "       cp ${REPO_DIR}/settings/settings.example.json ~/.claude/settings.json"
echo "     Or merge it with an existing ~/.claude/settings.json."
echo "     See docs/permissions.md for details."
echo
echo "  2. Test with 2-3 sample PPMs:"
echo "       mkdir -p ~/ppm-test/in ~/ppm-test/out"
echo "       # drop a few PDFs into ~/ppm-test/in"
echo "       claude"
echo "       /process-ppms ~/ppm-test/in ~/ppm-test/out"
echo
echo "  3. Read sub-agents/ppm-extractor/USAGE.md for the full reference."
