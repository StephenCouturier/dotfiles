#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: bug-wt.sh <create KEY SLUG|path KEY|remove KEY|list|clean>" >&2
  exit 64
}

[ $# -ge 1 ] || usage
cmd=$1
key=${2:-}
slug=${3:-}

root=$(git rev-parse --show-toplevel)
if [ "$(git rev-parse --git-common-dir)" != "$(git rev-parse --git-dir)" ]; then
  echo "run bug-wt.sh from the main checkout, not a worktree" >&2
  exit 1
fi
repo=$(basename "$root")
base_dir=${PI_BUG_SPRAY_WT_DIR:-$HOME/.pi/agent/worktrees}/$repo-bug-spray
dir=$base_dir/$key
author=${BUG_SPRAY_AUTHOR:-$(git config user.name | awk '{print tolower($1)}')}
base_ref=${BUG_SPRAY_BASE:-origin/main}

need_key() {
  [ -n "$key" ] || usage
}

case $cmd in
  create)
    need_key
    [ -n "$slug" ] || usage
    [ -n "$author" ] || { echo "set BUG_SPRAY_AUTHOR or git user.name" >&2; exit 1; }
    branch=$author/$key/$slug
    if [ -e "$dir" ]; then
      echo "already exists: $dir" >&2
      exit 1
    fi
    if git -C "$root" show-ref --verify --quiet "refs/heads/$branch"; then
      echo "branch already exists: $branch" >&2
      exit 1
    fi
    mkdir -p "$base_dir"
    git -C "$root" fetch --quiet origin "${base_ref#origin/}"
    git -C "$root" worktree add --quiet -b "$branch" "$dir" "$base_ref"
    echo "$dir"
    ;;
  path)
    need_key
    [ -d "$dir" ] || { echo "unknown worktree: $key" >&2; exit 1; }
    echo "$dir"
    ;;
  remove)
    need_key
    if [ -d "$dir" ]; then
      git -C "$root" worktree remove --force "$dir"
    fi
    echo "removed: $key (branch kept)"
    ;;
  list)
    git -C "$root" worktree list | grep -F "$base_dir/" || true
    ;;
  clean)
    for d in "$base_dir"/*/; do
      [ -d "$d" ] || continue
      git -C "$root" worktree remove --force "$d" || true
    done
    rmdir "$base_dir" 2>/dev/null || true
    git -C "$root" worktree prune
    echo "cleaned: $base_dir (branches kept)"
    ;;
  *)
    usage
    ;;
esac
