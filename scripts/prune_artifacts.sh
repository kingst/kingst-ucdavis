#!/usr/bin/env bash
#
# Prune old App Engine build artifacts, keeping the most recent ones.
#
# Deploy artifacts live in two different places, because App Engine migrated
# build storage from Container Registry to Artifact Registry in March 2025:
#
#   Artifact Registry  us-central1/gae-standard   <- current, grows every deploy
#   GCS bucket         us.artifacts.<project>...  <- legacy, frozen 2025-03-03
#
# By default this prunes the Artifact Registry repo, mirroring
# prune_versions.sh: the image tagged `latest` is always kept (the analogue of
# the serving version), plus the newest --keep images per package.
#
# The legacy GCS bucket is a separate mode, --legacy-bucket, because its
# contents are content-addressed blobs with no manifest index left. They can't
# be grouped into images, so "keep the newest N" is meaningless there and the
# only sensible operation is to drop all of it. See the notes in that section.
#
# Dry run (default):
#   ./scripts/prune_artifacts.sh
# Actually delete:
#   ./scripts/prune_artifacts.sh --yes

set -euo pipefail

PROJECT="kingst-ucd"
LOCATION="us-central1"
REPOSITORY="gae-standard"
KEEP=10
CONFIRM=0
LEGACY=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -p, --project ID    GCP project (default: $PROJECT)
  -l, --location LOC  Artifact Registry location (default: $LOCATION)
  -r, --repository R  Artifact Registry repo (default: $REPOSITORY)
  -k, --keep N        Images to retain per package, newest first (default: $KEEP)
      --legacy-bucket Purge the legacy GCS artifacts bucket instead. Deletes
                      ALL of it; see the header comment for why keep-N does
                      not apply.
  -y, --yes           Actually delete. Without this, prints what it would do.
  -h, --help          Show this message.

Images tagged 'latest' are always retained, in addition to --keep.
EOF
}

while [ $# -gt 0 ]; do
    # Accept --opt=value as well as --opt value, since gcloud takes both.
    case "$1" in
        --*=*)
            value="${1#*=}"
            set -- "${1%%=*}" "$value" "${@:2}"
            ;;
    esac
    case "$1" in
        -p|--project)    PROJECT="${2:?--project needs a value}";       shift 2 ;;
        -l|--location)   LOCATION="${2:?--location needs a value}";     shift 2 ;;
        -r|--repository) REPOSITORY="${2:?--repository needs a value}"; shift 2 ;;
        -k|--keep)       KEEP="${2:?--keep needs a value}";             shift 2 ;;
        --legacy-bucket) LEGACY=1;  shift ;;
        -y|--yes)        CONFIRM=1; shift ;;
        -h|--help)       usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
done

case "$KEEP" in
    ''|*[!0-9]*) echo "--keep must be a non-negative integer, got: $KEEP" >&2; exit 1 ;;
esac

# Every `gcloud artifacts` call prints a "Listing items under project ..."
# banner to stderr, followed by a blank line. Drop both so they do not
# interleave with the report, while letting real errors through.
ar() {
    local err out rc
    err=$(mktemp)
    out=$(gcloud "$@" 2>"$err"); rc=$?
    grep -v '^Listing items under project' "$err" \
        | grep -v '^[[:space:]]*$' >&2 || true
    rm -f "$err"
    [ "$rc" -eq 0 ] || return "$rc"
    printf '%s' "$out"
}

# ---------------------------------------------------------------------------
# Legacy GCS bucket
# ---------------------------------------------------------------------------
# These blobs predate the Artifact Registry migration and nothing references
# them: the Container Registry index they belonged to is gone, so there is no
# manifest tree mapping blobs to images. Deleting a subset by timestamp would
# be actively unsafe if anything did still use them, since images share
# content-addressed layers. All-or-nothing is the only coherent option.
if [ "$LEGACY" -eq 1 ]; then
    BUCKET="gs://us.artifacts.${PROJECT}.appspot.com"
    echo "Legacy bucket: $BUCKET"
    echo

    if ! gcloud storage ls "$BUCKET" >/dev/null 2>&1; then
        echo "Bucket does not exist or is not readable. Nothing to do."
        exit 0
    fi

    newest=$(gcloud storage ls -l "$BUCKET/**" 2>/dev/null \
        | grep -o '[0-9]\{4\}-[0-9][0-9]-[0-9][0-9]T[0-9:]*Z' | sort | tail -1)
    size=$(gcloud storage du -s --readable-sizes "$BUCKET" 2>/dev/null | awk '{print $1}')

    echo "Size: ${size:-unknown}   Newest object: ${newest:-none}"
    echo

    # If anything landed here after the Artifact Registry cutover, the
    # assumption that this bucket is dead no longer holds.
    if [ -n "$newest" ] && [ "$newest" \> "2025-04-01" ]; then
        echo "Refusing to run: this bucket has objects newer than 2025-04-01," >&2
        echo "so it may still be in active use. Inspect it before purging." >&2
        exit 1
    fi

    if [ "$CONFIRM" -ne 1 ]; then
        echo "Dry run. Re-run with --legacy-bucket --yes to delete ALL of it."
        exit 0
    fi

    gcloud storage rm -r "$BUCKET/**" --project="$PROJECT"
    echo "Purged $BUCKET."
    exit 0
fi

# ---------------------------------------------------------------------------
# Artifact Registry
# ---------------------------------------------------------------------------
REPO="${LOCATION}-docker.pkg.dev/${PROJECT}/${REPOSITORY}"
echo "Repo: $REPO   Keep: $KEEP"
echo

packages=$(ar artifacts packages list \
    --repository="$REPOSITORY" --location="$LOCATION" --project="$PROJECT" \
    --format="value(name)")

if [ -z "$packages" ]; then
    echo "No packages found in $REPO." >&2
    exit 1
fi

total_doomed=0
doomed_all=""

while IFS= read -r pkg; do
    [ -n "$pkg" ] || continue
    echo "Package: $pkg"

    # Tagged 'latest' is the image backing the current deploy. Held out by
    # digest rather than by position, so it survives regardless of sort order.
    keepers=$(ar artifacts docker images list "$REPO/$pkg" \
        --project="$PROJECT" --include-tags --filter="tags:latest" \
        --format="value(version)" || true)

    if [ -n "$keepers" ]; then
        echo "$keepers" | sed 's/^/  latest: /'
    else
        echo "  (no image tagged latest)"
    fi

    all=$(ar artifacts docker images list "$REPO/$pkg" \
        --project="$PROJECT" --sort-by="~createTime" --format="value(version)")

    n=0
    pkg_doomed=""
    while IFS= read -r digest; do
        [ -n "$digest" ] || continue
        if printf '%s\n' "$keepers" | grep -qxF "$digest"; then
            continue
        fi
        n=$((n + 1))
        [ "$n" -le "$KEEP" ] && continue
        pkg_doomed="$pkg_doomed$REPO/$pkg@$digest"$'\n'
    done <<EOF
$all
EOF

    count_all=$(printf '%s' "$all" | grep -c . || true)
    count=$(printf '%s' "$pkg_doomed" | grep -c . || true)
    echo "  images: $count_all   to delete: $count"
    echo

    total_doomed=$((total_doomed + count))
    doomed_all="$doomed_all$pkg_doomed"
done <<EOF
$packages
EOF

if [ "$total_doomed" -eq 0 ]; then
    echo "Nothing to prune."
    exit 0
fi

echo "Total to delete: $total_doomed"
echo

if [ "$CONFIRM" -ne 1 ]; then
    printf '%s' "$doomed_all" | sed 's/^/  delete /' | head -20
    [ "$total_doomed" -gt 20 ] && echo "  ... and $((total_doomed - 20)) more"
    echo
    echo "Dry run. Re-run with --yes to delete these $total_doomed images."
    exit 0
fi

# --delete-tags is required for images carrying tags; without it the call
# fails rather than silently skipping.
#
# Artifact Registry deletes one image per call, so 80+ sequential calls take
# minutes. Run them in small parallel batches instead. bash 3.2 on macOS has
# no `wait -n`, so this waits on a whole batch at a time. Subshells cannot
# update a counter in the parent, so failures are recorded in a file and
# counted at the end -- the summary must report what actually happened, not
# what was attempted.
failures=$(mktemp)
trap 'rm -f "$failures"' EXIT

attempted=0
batch=0
for image in $doomed_all; do
    (
        if ! err=$(gcloud artifacts docker images delete "$image" \
                --project="$PROJECT" --delete-tags --quiet 2>&1); then
            printf '%s\t%s\n' "$image" "$(printf '%s' "$err" | tr '\n' ' ')" \
                >> "$failures"
        fi
    ) &
    batch=$((batch + 1))
    attempted=$((attempted + 1))
    if [ "$batch" -ge 8 ]; then
        wait
        batch=0
        echo "  ... $attempted/$total_doomed"
    fi
done
wait

failed=$(grep -c . "$failures" 2>/dev/null || true)
: "${failed:=0}"
deleted=$((attempted - failed))

echo
echo "Deleted $deleted of $total_doomed images."
if [ "$failed" -gt 0 ]; then
    echo "Failed: $failed" >&2
    sed 's/^/  /' "$failures" >&2
fi

size=$(gcloud artifacts repositories describe "$REPOSITORY" \
    --location="$LOCATION" --project="$PROJECT" \
    --format="value(sizeBytes)" 2>/dev/null || true)
if [ -n "$size" ]; then
    echo "Repo size now: $size bytes."
fi

[ "$failed" -eq 0 ]
