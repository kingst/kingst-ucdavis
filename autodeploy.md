# Autodeploy

Our job is to create a script that listens for updates to a github
repo and when there are any new commits to the `master` branch do a
new Google App Engine deploy.

To keep things simple, this script will run in a tmux terminal on a
mac mini.

## Details

Repo: https://github.com/kingst/kingst-ucdavis
Deploy script: deploy.sh
Assume: gcp auth is already active on the local machine

## Logging

For logging we can just print information to stdout since this is
going to be a command line application running in a terminal.

If there is an error an it's not able to deploy, I'd love for the
system to email: kingst@ucdavis.edu if possible.