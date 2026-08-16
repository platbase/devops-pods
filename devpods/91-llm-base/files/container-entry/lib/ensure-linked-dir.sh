#!/bin/bash
# =============================================================================
# ensure-linked-dir.sh
# =============================================================================
# Background:
#   In container environments, the /data directory is typically mounted as a
#   persistent volume (VOLUME) on the host. Users want data under certain
#   paths (e.g. /root/.config, /root/.cache) to survive container restarts,
#   without modifying the application's default configuration paths.
#
# Design:
#   Adopts a "symlink hijacking" strategy:
#   1. Create a mirrored directory structure under /data/<namespace>/ as the
#      actual storage location.
#   2. Replace the source path (e.g. /root/.config) with a symlink pointing to
#      /data/<namespace>/.config.
#   3. If the source path already exists and is not the correct symlink,
#      rename it with a timestamp suffix to avoid data loss, then create the
#      symlink.
#
#   This strategy is transparent to applications: they still access
#   /root/.config, but data is actually written to /data/..., naturally
#   persisting across container restarts.
#
# Functions:
#   ensure_linked_dir <fromBase> <toBase> <relPath>
#     - fromBase : Base directory of the source path (e.g. /root)
#     - toBase   : Base directory of the persistent storage (e.g. /data/opencode)
#     - relPath  : Relative path (e.g. .config, .local/share/opentui)
#
#   batch_ensure_linked <fromBase> <toBase> <relPath> [<relPath> ...]
#     - Batch wrapper for ensure_linked_dir, useful for processing multiple
#       paths at once.
#
# Usage example:
#   source /usr/local/bin/ensure-linked-dir.sh
#   ensure_linked_dir "/root" "/data/opencode" ".config"
#   batch_ensure_linked "/root" "/data/opencode" ".cache" ".local/share"
#
# Notes:
#   1. Designed to run during container entrypoint / init phase. Ensure the
#      target volume is mounted before execution.
#   2. Backup files are named "<original>.YYYYMMDD_HHMMSS" and kept in the
#      same parent directory as fromBase.
#   3. If relPath is empty or ".", the function aborts to prevent accidental
#      linking of the base directory itself.
#   4. Symlink targets use absolute paths to avoid relative path resolution
#      ambiguity.
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Logging helpers
# -----------------------------------------------------------------------------
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'
log_ok()   { echo -e "${GREEN}[OK]${NC} $*"; }
log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_err()  { echo -e "${RED}[ERR]${NC} $*" >&2; }

# -----------------------------------------------------------------------------
# Core function
# -----------------------------------------------------------------------------
# Ensures that ${fromBase}/${relPath} is a symlink pointing to
# ${toBase}/${relPath}. If not, backs up the existing file/directory/symlink
# and creates the correct symlink.
# -----------------------------------------------------------------------------
ensure_linked_dir() {
    local fromBase="$1"
    local toBase="$2"
    local relPath="$3"

    # Validate arguments
    if [[ -z "$fromBase" || -z "$toBase" || -z "$relPath" ]]; then
        log_err "ensure_linked_dir: arguments cannot be empty (fromBase='$fromBase', toBase='$toBase', relPath='$relPath')"
        return 1
    fi

    # Normalize paths: strip trailing slashes, strip leading slash from relPath
    fromBase="${fromBase%/}"
    toBase="${toBase%/}"
    relPath="${relPath#/}"

    local srcPath="${fromBase}/${relPath}"
    local dstPath="${toBase}/${relPath}"

    # Prevent operating on the base directory itself
    if [[ -z "$relPath" || "$relPath" == "." ]]; then
        log_err "ensure_linked_dir: relPath cannot be '.' or empty (refusing to link the base directory itself)"
        return 1
    fi

    # Case 1: Already a correct symlink
    if [[ -L "$srcPath" ]]; then
        local currentTarget
        currentTarget=$(readlink -f "$srcPath" 2>/dev/null || readlink "$srcPath")
        if [[ "$currentTarget" == "$dstPath" ]]; then
            log_ok "${srcPath} -> ${dstPath}"
            return 0
        fi
        log_warn "${srcPath} exists but points to '${currentTarget}' (expected '${dstPath}')"
    elif [[ -e "$srcPath" ]]; then
        local ftype="unknown"
        [[ -d "$srcPath" ]] && ftype="directory"
        [[ -f "$srcPath" ]] && ftype="regular file"
        [[ -L "$srcPath" ]] && ftype="symlink"
        [[ -p "$srcPath" ]] && ftype="named pipe"
        [[ -S "$srcPath" ]] && ftype="socket"
        log_warn "${srcPath} exists but is not a symlink (type: ${ftype})"
    fi

    # Case 2: Backup existing file/directory/symlink with timestamp
    local ts; ts=$(date +%Y%m%d_%H%M%S)
    if [[ -e "$srcPath" || -L "$srcPath" ]]; then
        local backupPath="${srcPath}.${ts}"
        mv -v "$srcPath" "$backupPath"
        log_info "Backed up: ${srcPath} -> ${backupPath}"
    fi

    # Case 3: Ensure parent directory of srcPath exists
    local parentDir; parentDir=$(dirname "$srcPath")
    if [[ ! -d "$parentDir" ]]; then
        mkdir -p "$parentDir"
        log_info "Created parent directory: ${parentDir}"
    fi

    # Case 4: Ensure destination persistent directory exists
    if [[ ! -d "$dstPath" ]]; then
        mkdir -p "$dstPath"
        log_info "Created target directory: ${dstPath}"
    fi

    # Case 5: Create the symlink
    ln -s "$dstPath" "$srcPath"
    log_ok "Linked: ${srcPath} -> ${dstPath}"
}

# -----------------------------------------------------------------------------
# Batch helper: process multiple relPaths with the same bases
# -----------------------------------------------------------------------------
# Usage: batch_ensure_linked <fromBase> <toBase> <relPath> [relPath ...]
# -----------------------------------------------------------------------------
batch_ensure_linked() {
    if [[ $# -lt 3 ]]; then
        log_err "batch_ensure_linked: requires at least 3 arguments (fromBase, toBase, relPath...)"
        return 1
    fi

    local fromBase="$1"
    local toBase="$2"
    shift 2

    for relPath in "$@"; do
        ensure_linked_dir "$fromBase" "$toBase" "$relPath"
    done
}

# =============================================================================
# Example usage (uncomment to run directly, or source this script and call
# ensure_linked_dir / batch_ensure_linked from your own script)
# =============================================================================

# batch_ensure_linked "/root" "/data/opencode" \
#     ".local/share/opencode" ".local/share/opentui" ".local/state/opencode"
