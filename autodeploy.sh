#!/bin/bash

# Autodeploy script for kingst-ucdavis
# Polls GitHub for new commits on master and deploys to Google App Engine
# Intended to run in a tmux session on a Mac Mini

REPO_DIR="/Users/kingst/work/kingst-ucdavis"
BRANCH="master"
POLL_INTERVAL=60  # seconds between checks
EMAIL="kingst@ucdavis.edu"
LAST_DEPLOYED_FILE="$REPO_DIR/.last_deployed_sha"
DEPLOYS_LOG="$REPO_DIR/deploys.txt"
FORCE_DEPLOY_FILE="$REPO_DIR/.force_deploy"

cd "$REPO_DIR" || exit 1

# Initialize last deployed SHA from file, or use current HEAD
if [ -f "$LAST_DEPLOYED_FILE" ]; then
    LAST_DEPLOYED_SHA=$(cat "$LAST_DEPLOYED_FILE")
    echo "$(date): Resuming from last deployed SHA: ${LAST_DEPLOYED_SHA:0:7}"
else
    LAST_DEPLOYED_SHA=$(git rev-parse "$BRANCH")
    echo "$LAST_DEPLOYED_SHA" > "$LAST_DEPLOYED_FILE"
    echo "$(date): No prior deploy state found, starting from current HEAD: ${LAST_DEPLOYED_SHA:0:7}"
fi

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

    REMOTE_SHA=$(git rev-parse "origin/$BRANCH")

    # Check for force deploy trigger
    FORCE_DEPLOY=false
    if [ -f "$FORCE_DEPLOY_FILE" ]; then
        echo "$(date): Force deploy triggered"
        rm "$FORCE_DEPLOY_FILE"
        FORCE_DEPLOY=true
    fi

    if [ "$LAST_DEPLOYED_SHA" != "$REMOTE_SHA" ] || [ "$FORCE_DEPLOY" = true ]; then
        echo "$(date): New commits detected (deployed: ${LAST_DEPLOYED_SHA:0:7}, remote: ${REMOTE_SHA:0:7})"

        # Collect commit details before pulling
        COMMIT_LOG=$(git log --oneline "$LAST_DEPLOYED_SHA".."origin/$BRANCH")
        echo "$(date): Commits to deploy:"
        echo "$COMMIT_LOG"

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

            # Log to deploys.txt
            {
                echo "=== Deploy $(date) ==="
                echo "Previous SHA: ${LAST_DEPLOYED_SHA:0:7}"
                echo "Deployed SHA: ${REMOTE_SHA:0:7}"
                echo "Commits:"
                echo "$COMMIT_LOG"
                echo ""
            } >> "$DEPLOYS_LOG"

            # Update last deployed SHA
            echo "$REMOTE_SHA" > "$LAST_DEPLOYED_FILE"
            LAST_DEPLOYED_SHA="$REMOTE_SHA"
        else
            echo "$(date): ERROR - deploy failed"
            send_error_email "Autodeploy: deploy failed" "gcloud app deploy failed at $(date). Check the tmux session for details."
        fi
    else
        echo "$(date): No new commits"
    fi

    sleep "$POLL_INTERVAL"
done
