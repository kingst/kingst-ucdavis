#!/bin/bash

# Autodeploy script for kingst-ucdavis
# Polls GitHub for new commits on master and deploys to Google App Engine
# Intended to run in a tmux session on a Mac Mini

REPO_DIR="/Users/kingst/work/kingst-ucdavis"
BRANCH="master"
POLL_INTERVAL=60  # seconds between checks
EMAIL="kingst@ucdavis.edu"

cd "$REPO_DIR" || exit 1

send_error_email() {
    local subject="$1"
    local body="$2"
    echo "$body" | mailx -s "$subject" "$EMAIL"
}

echo "$(date): Autodeploy started, watching $BRANCH branch (polling every ${POLL_INTERVAL}s)"

while true; do
    # Fetch latest from remote
    if ! git fetch origin "$BRANCH" 2>&1; then
        echo "$(date): ERROR - git fetch failed"
        send_error_email "Autodeploy: git fetch failed" "git fetch origin $BRANCH failed at $(date)"
        sleep "$POLL_INTERVAL"
        continue
    fi

    LOCAL_SHA=$(git rev-parse "$BRANCH")
    REMOTE_SHA=$(git rev-parse "origin/$BRANCH")

    if [ "$LOCAL_SHA" != "$REMOTE_SHA" ]; then
        echo "$(date): New commits detected (local: ${LOCAL_SHA:0:7}, remote: ${REMOTE_SHA:0:7})"
        echo "$(date): Pulling latest changes..."

        if ! git pull origin "$BRANCH" 2>&1; then
            echo "$(date): ERROR - git pull failed"
            send_error_email "Autodeploy: git pull failed" "git pull origin $BRANCH failed at $(date)"
            sleep "$POLL_INTERVAL"
            continue
        fi

        echo "$(date): Deploying..."
        gcloud config set account kingst@ucdavis.edu
        if gcloud app deploy --project=kingst-ucd --promote --quiet 2>&1; then
            echo "$(date): Deploy successful"
        else
            echo "$(date): ERROR - deploy failed"
            send_error_email "Autodeploy: deploy failed" "gcloud app deploy failed at $(date). Check the tmux session for details."
        fi
    else
        echo "$(date): No new commits"
    fi

    sleep "$POLL_INTERVAL"
done
