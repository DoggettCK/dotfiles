#!/usr/bin/env bash
set -euo pipefail

# ---------- CONFIG ----------
# UUID of the backup drive, read from the environment.
DEST_UUID="${USB_BACKUP_UUID:-}"

if [[ -z "$DEST_UUID" ]]; then
  cat >&2 <<'EOF'
Error: USB_BACKUP_UUID is not set.

1. Find your backup drive's UUID:
     lsblk -f

2. Set it for this shell session:
     export USB_BACKUP_UUID="your-uuid-here"

   Or make it permanent by adding that same line to ~/.bashrc
   (then run: source ~/.bashrc)
EOF
  exit 1
fi

DEST_MOUNT="$(findmnt -rn -S "UUID=$DEST_UUID" -o TARGET || true)"

# Directories to back up (no trailing slash)
SOURCES=(
  "$HOME/Dropbox"
  "$HOME/Documents"
)

# Patterns to skip (rsync exclude syntax)
EXCLUDES=(
  ".dropbox.cache"
  ".Trash-*"
  "node_modules"
)

LOG="$HOME/.local/state/usb-backup.log"
# ----------------------------

DRY=()
[[ "${1:-}" == "--dry-run" ]] && DRY=(--dry-run) && echo "*** DRY RUN ***"

mkdir -p "$(dirname "$LOG")"

# Safety: drive must be mounted
if [[ -z "$DEST_MOUNT" ]] || ! mountpoint -q "$DEST_MOUNT"; then
  echo "Backup drive (UUID $DEST_UUID) not mounted. Aborting." | tee -a "$LOG"
  exit 1
fi

# Prevent overlapping runs
exec 9>"/tmp/usb-backup.lock"
flock -n 9 || { echo "Backup already running."; exit 1; }

EXCLUDE_ARGS=()
for e in "${EXCLUDES[@]}"; do EXCLUDE_ARGS+=(--exclude="$e"); done

for src in "${SOURCES[@]}"; do
  if [[ ! -d "$src" ]]; then
    echo "Skipping missing source: $src" | tee -a "$LOG"
    continue
  fi
  dest="$DEST_MOUNT/backups/$(basename "$src")"
  mkdir -p "$dest"
  echo "[$(date '+%F %T')] $src -> $dest" | tee -a "$LOG"
  rsync -aH --delete --delete-excluded --info=stats1 \
        "${EXCLUDE_ARGS[@]}" "${DRY[@]}" \
        "$src/" "$dest/" 2>&1 | tee -a "$LOG"
done

echo "[$(date '+%F %T')] Done." | tee -a "$LOG"
