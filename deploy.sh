#!/bin/bash

if [ "$(git symbolic-ref --short HEAD)" != "main" ]; then
    echo 'will only deploy from main, bailing'
    exit
fi

if [ -z "$(git status --porcelain)" ]; then
    echo 'git status is clean, doing a push and deploying...'
else
    echo 'uncommitted changes, run `git status` for more information'
    exit
fi
git push

gcloud config set account kingst@ucdavis.edu
gcloud app deploy --project=kingst-ucdavis --promote
