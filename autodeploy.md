# Autodeploy

Our job is to create a script that listens for updates to a github
repo and when there are any new commits to the `master` branch do a
new Google App Engine deploy.

To keep things simple, this script will run in a tmux terminal on a
mac mini, but we can make it more sophisticated as needed.

## Running it

To run it:

```bash
$ tmux new -s autodeploy
# ./autodeploy.sh
```

Then detach with `Ctrl-b d`. Reattach later with `tmux attach -t
autodeploy`.

## Details

Repo: https://github.com/kingst/kingst-ucdavis
Deploy script: deploy.sh
Assume: gcp auth is already active on the local machine

## Logging

For logging we can just print information to stdout since this is
going to be a command line application running in a terminal.

If there is an error an it's not able to deploy, I'd love for the
system to email: kingst@ucdavis.edu if possible.

If there is a successful deploy, provide some details about the new
commits that were included in a file called `deploys.txt`

## Force Deploy

To trigger a deploy without pushing a new commit:

```bash
$ touch .force_deploy
```

The script picks this up on the next poll cycle (within 60 seconds),
deploys the current state, and removes the file.

## Error Recovery

The last successfully deployed SHA is stored in `.last_deployed_sha`.
On each poll, the script compares this value against the remote HEAD
rather than relying on the local git branch. If a deploy fails, the
SHA is not updated, so the next poll will retry automatically. This
also survives script restarts.