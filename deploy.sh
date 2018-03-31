#!/bin/bash
#appcfg.py --email=kingst@gmail.com update .
gcloud app deploy --project=kingst-ucd --promote
gcloud app deploy --project=kingst-ucdavis --promote
./cleanup_old_version.sh kingst-ucdavis
./cleanup_old_version.sh kingst-ucd