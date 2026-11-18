#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: wt.sh <create|patch|apply|remove|list|clean> [name]" >&2
  exit 64
}

[ $# -ge 1 ] || usage
cmd=$1
name=${2:-}

root=$(git rev-parse --show-toplevel)
if [ "$(git rev-parse --git-common-dir)" != "$(git rev-parse --git-dir)" ]; then
  echo "run wt.sh from the main checkout, not a worktree" >&2
  exit 1
fi
repo=$(basename "$root")
base_dir=${PI_SPEC_WT_DIR:-$HOME/.pi/agent/worktrees}/$repo
dir=$base_dir/$name
meta=$base_dir/.$name

need_name() {
  [ -n "$name" ] || usage
}

snapshot_tree() {
  git -C "$1" add -A >/dev/null
  git -C "$1" write-tree
}

case $cmd in
  create)
    need_name
    if [ -e "$dir" ]; then
      echo "already exists: $dir" >&2
      exit 1
    fi
    mkdir -p "$base_dir"
    git -C "$root" worktree add --detach --quiet "$dir" HEAD
    git -C "$root" diff HEAD --binary > "$meta.base.patch"
    if [ -s "$meta.base.patch" ]; then
      git -C "$dir" apply --binary "$meta.base.patch"
    fi
    (cd "$root" && git ls-files -z --others --exclude-standard | tar --null -T - -cf -) | (cd "$dir" && tar -xf -)
    snapshot_tree "$dir" > "$meta.base"
    echo "$dir"
    ;;
  patch)
    need_name
    [ -f "$meta.base" ] || { echo "unknown worktree: $name" >&2; exit 1; }
    new=$(snapshot_tree "$dir")
    git -C "$dir" diff --binary "$(cat "$meta.base")" "$new" -- . ':(exclude).scratch' > "$meta.patch"
    echo "$meta.patch"
    ;;
  apply)
    need_name
    "$0" patch "$name" >/dev/null
    if [ ! -s "$meta.patch" ]; then
      echo "empty patch: $name"
      exit 0
    fi
    if git -C "$root" apply --check --binary "$meta.patch" 2>/dev/null; then
      git -C "$root" apply --binary "$meta.patch"
      echo "applied: $name"
      exit 0
    fi
    tmp_index=$(mktemp)
    rm -f "$tmp_index"
    export GIT_INDEX_FILE=$tmp_index
    git -C "$root" read-tree HEAD
    git -C "$root" add -A >/dev/null
    if git -C "$root" apply --3way --binary "$meta.patch" 2>"$meta.conflict"; then
      rm -f "$tmp_index" "$meta.conflict"
      echo "applied (3-way): $name"
    else
      rm -f "$tmp_index"
      echo "conflict: $name" >&2
      echo "patch: $meta.patch" >&2
      cat "$meta.conflict" >&2
      exit 2
    fi
    ;;
  remove)
    need_name
    if [ -d "$dir" ]; then
      git -C "$root" worktree remove --force "$dir"
    fi
    rm -f "$meta".*
    echo "removed: $name"
    ;;
  list)
    ls -1 "$base_dir" 2>/dev/null || true
    ;;
  clean)
    for d in "$base_dir"/*/; do
      [ -d "$d" ] || continue
      git -C "$root" worktree remove --force "$d" || true
    done
    rm -rf "$base_dir"
    git -C "$root" worktree prune
    echo "cleaned: $base_dir"
    ;;
  *)
    usage
    ;;
esac
