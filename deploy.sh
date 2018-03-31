#!/bin/bash

if [ "$(git symbolic-ref --short HEAD)" != "master" ]; then
    echo 'will only deploy from master, bailing'
    exit
fi

if [ -z "$(git status --porcelain)" ]; then 
    echo 'git status is clean, doing a push and deploying...'
else 
    echo 'uncommitted changes, run `git status` for more information'
    exit
fi
git push
#version=`git rev-parse HEAD`
gcloud app deploy --project=kingst-ucd --promote
gcloud app deploy --project=kingst-ucdavis --promote
./cleanup_old_version.sh kingst-ucdavis
./cleanup_old_version.sh kingst-ucd