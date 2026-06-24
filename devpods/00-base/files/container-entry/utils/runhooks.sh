#!/bin/bash
#
# Execute hook scripts from /container-entry/hooks.
#
# This script iterates over subdirectories under /container-entry/hooks in
# sorted order, then executes all *.rc files with executable permission (+x)
# found within each subdirectory, also in sorted order.
#
# Design notes:
# - find -print0 | sort -z: Safely handles directory and file names containing
#   spaces, newlines, or other special characters.
# - -maxdepth 1: Restricts search to the immediate subdirectory level; no
#   recursive descent into deeper nested directories.
# - [[ -x "$script" ]]: Only files with the executable bit set are run.
# - If the hooks directory does not exist, a warning is printed and the script
#   exits with code 0 to avoid failing container startup.
#
set -euo pipefail

HOOKS_DIR="/container-entry/hooks"

[[ -d "$HOOKS_DIR" ]] || { echo ">> [Hooks] Hooks dir missing: $HOOKS_DIR" >&2; exit 0; }

# Iterate subdirectories in sorted order
while IFS= read -r -d '' dir; do
    [[ -d "$dir" ]] || continue

    # Execute executable .rc files in sorted order within each subdirectory
    while IFS= read -r -d '' script; do
        [[ -x "$script" ]] || continue

        echo ">> [Hooks] Executing hook: $script ..."
        "$script"
    done < <(find "$dir" -maxdepth 1 -type f -name '*.rc' -print0 | sort -z)

done < <(find "$HOOKS_DIR" -maxdepth 1 -mindepth 1 -type d -print0 | sort -z)