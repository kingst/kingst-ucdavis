#!/usr/bin/env bash
#
# Prune old App Engine versions, keeping the most recent ones for rollback.
#
# App Engine caps a service at 210 versions and bills storage for every one,
# so frequent deploys eventually wedge the service. This deletes the oldest
# zero-traffic versions and leaves the newest --keep of them alone.
#
# Versions receiving traffic are never deleted.
#
# Dry run (default):
#   ./scripts/prune_versions.sh
# Actually delete:
#   ./scripts/prune_versions.sh --yes

set -euo pipefail

PROJECT="kingst-ucd"
SERVICE="default"
KEEP=10
CONFIRM=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -p, --project ID   GCP project (default: $PROJECT)
  -s, --service NAME App Engine service (default: $SERVICE)
  -k, --keep N       Zero-traffic versions to retain, newest first (default: $KEEP)
  -y, --yes          Actually delete. Without this, prints what it would do.
  -h, --help         Show this message.

The version currently serving traffic is always retained, in addition to --keep.
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
        -p|--project) PROJECT="${2:?--project needs a value}"; shift 2 ;;
        -s|--service) SERVICE="${2:?--service needs a value}"; shift 2 ;;
        -k|--keep)    KEEP="${2:?--keep needs a value}";       shift 2 ;;
        -y|--yes)     CONFIRM=1;    shift ;;
        -h|--help)    usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
done

case "$KEEP" in
    ''|*[!0-9]*) echo "--keep must be a non-negative integer, got: $KEEP" >&2; exit 1 ;;
esac

echo "Project: $PROJECT   Service: $SERVICE   Keep: $KEEP"
echo

# Versions currently serving traffic. These are excluded from deletion below by
# name, not just by relying on the --filter, since deletion is irreversible.
serving=$(gcloud app versions list \
    --project="$PROJECT" --service="$SERVICE" \
    --filter="traffic_split>0" --format="value(id)")

if [ -z "$serving" ]; then
    echo "Refusing to run: no version is receiving traffic for $SERVICE." >&2
    echo "That usually means the wrong --service, or the app is disabled." >&2
    exit 1
fi

echo "Serving (always kept):"
echo "$serving" | sed 's/^/  /'
echo

# Zero-traffic versions, newest first, so `tail -n +N` drops the newest N-1.
candidates=$(gcloud app versions list \
    --project="$PROJECT" --service="$SERVICE" \
    --filter="traffic_split=0" --sort-by="~version.createTime" \
    --format="value(id)")

total=$(printf '%s' "$candidates" | grep -c . || true)

# Belt and braces: drop anything that showed up in the serving list.
doomed=""
n=0
while IFS= read -r v; do
    [ -n "$v" ] || continue
    if printf '%s\n' "$serving" | grep -qxF "$v"; then
        echo "Skipping $v (serving traffic)"
        continue
    fi
    n=$((n + 1))
    [ "$n" -le "$KEEP" ] && continue
    doomed="$doomed$v"$'\n'
done <<EOF
$candidates
EOF

doomed=$(printf '%s' "$doomed" | grep . || true)
count=$(printf '%s' "$doomed" | grep -c . || true)

echo "Zero-traffic versions: $total   Retaining newest: $KEEP   To delete: $count"

if [ "$count" -eq 0 ]; then
    echo "Nothing to prune."
    exit 0
fi

echo
echo "$doomed" | sed 's/^/  delete /'
echo

if [ "$CONFIRM" -ne 1 ]; then
    echo "Dry run. Re-run with --yes to delete these $count versions."
    exit 0
fi

# Delete in batches; one gcloud call per version is far slower, and a single
# call with 100+ arguments is more likely to time out.
batch=""
size=0
flush() {
    [ "$size" -gt 0 ] || return 0
    # shellcheck disable=SC2086
    gcloud app versions delete $batch \
        --project="$PROJECT" --service="$SERVICE" --quiet
    batch=""
    size=0
}

while IFS= read -r v; do
    [ -n "$v" ] || continue
    batch="$batch $v"
    size=$((size + 1))
    [ "$size" -ge 20 ] && flush
done <<EOF
$doomed
EOF
flush

echo
echo "Deleted $count versions."
remaining=$(gcloud app versions list --project="$PROJECT" --service="$SERVICE" --format="value(id)" | grep -c . || true)
echo "$SERVICE now has $remaining versions."
