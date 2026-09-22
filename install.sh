#!/usr/bin/env bash
#
# Symlink dotfiles from this repo into $HOME.
#
# Safe to run repeatedly. Existing files are backed up (not deleted) into
# ~/.dotfiles-backup/<timestamp>/ before being replaced by a symlink.
#
#   ./install.sh          # do it
#   DRY_RUN=1 ./install.sh  # show what would happen, change nothing

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="${HOME}/.dotfiles-backup"
STAMP="$(date +%Y-%m-%d-%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${STAMP}"
DRY_RUN="${DRY_RUN:-0}"

# Files to link. Add to this list as you add dotfiles.
FILES=(
  .bashrc
  .aliases
  .inputrc
  .gitconfig
  .vimrc
  .tmux.conf
  .editorconfig
  .gitignore_global
)

log()  { printf '[dotfiles] %s\n' "$*"; }
warn() { printf '[dotfiles] WARN: %s\n' "$*" >&2; }

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '  would: %s\n' "$*"
  else
    "$@"
  fi
}

link_one() {
  local name="$1"
  local src="${REPO_DIR}/${name}"
  local dest="${HOME}/${name}"

  if [[ ! -e "$src" ]]; then
    warn "missing in repo, skipping: ${name}"
    return 0
  fi

  # Already a correct symlink? Nothing to do. This is the idempotent path.
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    printf '  skip    %s (already correct)\n' "$name"
    return 0
  fi

  # Real file (or a symlink pointing elsewhere) -> back it up first.
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$DRY_RUN" != "1" ]]; then
      mkdir -p "$BACKUP_DIR"
    fi
    printf '  backup  %s -> %s\n' "$name" "${BACKUP_DIR#"$HOME"/}"
    run mv "$dest" "${BACKUP_DIR}/${name}"
  fi

  printf '  link    %s\n' "$name"
  run ln -s "$src" "$dest"
}

main() {
  log "repo: ${REPO_DIR}"
  if [[ "$DRY_RUN" == "1" ]]; then
    log "DRY RUN - nothing will be modified"
  fi

  for f in "${FILES[@]}"; do
    link_one "$f"
  done

  log "done."
  if [[ "$DRY_RUN" != "1" ]]; then
    log "backups (if any) are in ${BACKUP_DIR}"
    log "open a new shell, or: source ~/.bashrc"
  fi
}

main "$@"
