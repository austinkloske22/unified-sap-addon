#!/usr/bin/env bash
#
# gcts-sync.sh — Bidirectional sync between gCTS source and clone repos.
#
# The two repos share ABAP objects (objects/) and gCTS metadata (.gctsmetadata/)
# but have independent identity configs (.gcts.properties.json, README, etc.).
#
# Usage:
#   ./scripts/gcts-sync.sh forward   — source -> clone
#   ./scripts/gcts-sync.sh reverse   — clone -> source
#   ./scripts/gcts-sync.sh status    — dry-run showing what would change
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CLONE_DIR="$SOURCE_DIR/unified-sap-addon-clone"

# ── Preflight checks ──────────────────────────────────────────────────────────

check_repos() {
  if [ ! -d "$SOURCE_DIR/.git" ]; then
    echo "ERROR: Source repo not found at $SOURCE_DIR" >&2
    exit 1
  fi
  if [ ! -d "$CLONE_DIR/.git" ]; then
    echo "ERROR: Clone repo not found at $CLONE_DIR" >&2
    echo "Run: git clone git@github.com:austinkloske22/unified-sap-addon-clone.git $CLONE_DIR" >&2
    exit 1
  fi
}

# ── Sync logic ─────────────────────────────────────────────────────────────────

sync_content() {
  local from_dir="$1"
  local to_dir="$2"
  local dry_run="${3:-false}"

  local rsync_flags="-av"
  if [ "$dry_run" = "true" ]; then
    rsync_flags="-avn"
  fi

  echo ""
  echo "=== Syncing objects/ (mirror) ==="
  # --delete: remove files in target that don't exist in source
  if [ -d "$from_dir/objects" ]; then
    mkdir -p "$to_dir/objects"
    rsync $rsync_flags --delete "$from_dir/objects/" "$to_dir/objects/"
  else
    echo "  (no objects/ in source — skipping)"
  fi

  echo ""
  echo "=== Syncing .gctsmetadata/nametabs/ (additive) ==="
  # No --delete: preserve target-specific files (e.g. clone's ATO_E07.asx.json)
  if [ -d "$from_dir/.gctsmetadata/nametabs" ]; then
    mkdir -p "$to_dir/.gctsmetadata/nametabs"
    rsync $rsync_flags "$from_dir/.gctsmetadata/nametabs/" "$to_dir/.gctsmetadata/nametabs/"
  else
    echo "  (no nametabs/ in source — skipping)"
  fi

  echo ""
  echo "=== Syncing .gctsmetadata/objecttypes/ (additive) ==="
  if [ -d "$from_dir/.gctsmetadata/objecttypes" ]; then
    mkdir -p "$to_dir/.gctsmetadata/objecttypes"
    rsync $rsync_flags "$from_dir/.gctsmetadata/objecttypes/" "$to_dir/.gctsmetadata/objecttypes/"
  else
    echo "  (no objecttypes/ in source — skipping)"
  fi
}

# ── Commit and push ────────────────────────────────────────────────────────────

commit_and_push() {
  local target_dir="$1"
  local from_dir="$2"

  cd "$target_dir"
  git add objects/ .gctsmetadata/

  if git diff --cached --quiet 2>/dev/null; then
    echo ""
    echo "No changes to sync — repos are already in sync."
    return 0
  fi

  # Extract the latest commit message from the source of the sync
  local source_subject
  source_subject="$(cd "$from_dir" && git log -1 --format='%s')"

  local commit_msg="[SYNC] $source_subject"

  echo ""
  echo "=== Committing ==="
  echo "  Message: $commit_msg"
  git commit -m "$commit_msg"

  echo ""
  echo "=== Pushing ==="
  git push
  echo ""
  echo "Sync complete."
}

# ── Main ───────────────────────────────────────────────────────────────────────

usage() {
  echo "Usage: $0 {forward|reverse|status}" >&2
  echo "" >&2
  echo "  forward  — Sync source (Public Cloud) -> clone (BTP ABAP Env)" >&2
  echo "  reverse  — Sync clone (BTP ABAP Env) -> source (Public Cloud)" >&2
  echo "  status   — Dry run: show what would change (forward direction)" >&2
  exit 1
}

main() {
  local mode="${1:-}"

  if [ -z "$mode" ]; then
    usage
  fi

  check_repos

  case "$mode" in
    forward)
      echo "Syncing: source -> clone"
      echo "  Source: $SOURCE_DIR"
      echo "  Clone:  $CLONE_DIR"
      sync_content "$SOURCE_DIR" "$CLONE_DIR" false
      commit_and_push "$CLONE_DIR" "$SOURCE_DIR"
      ;;
    reverse)
      echo "Syncing: clone -> source"
      echo "  Clone:  $CLONE_DIR"
      echo "  Source: $SOURCE_DIR"
      sync_content "$CLONE_DIR" "$SOURCE_DIR" false
      commit_and_push "$SOURCE_DIR" "$CLONE_DIR"
      ;;
    status)
      echo "Dry run (forward: source -> clone):"
      echo "  Source: $SOURCE_DIR"
      echo "  Clone:  $CLONE_DIR"
      sync_content "$SOURCE_DIR" "$CLONE_DIR" true
      echo ""
      echo "(No changes were made — this was a dry run)"
      ;;
    *)
      usage
      ;;
  esac
}

main "$@"
