To run the Python scripts, you need to set up an appropriate Python3
environment using venv:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## prune_versions.sh

Deletes old App Engine versions. Needs only `gcloud`, no venv. App Engine
caps a service at 210 versions and bills storage for every one, so frequent
deploys eventually wedge the service.

```bash
./scripts/prune_versions.sh            # dry run: show what would go
./scripts/prune_versions.sh --yes      # actually delete
./scripts/prune_versions.sh --keep 25 --yes
```

Defaults to `kingst-ucd` / `default`, keeping the 10 newest zero-traffic
versions. The version serving traffic is never deleted. Deletion is
irreversible — a pruned version can only come back by redeploying.

## prune_artifacts.sh

Deletes old build artifacts, which `prune_versions.sh` does **not** touch.
Pruning versions leaves the images behind, and they are the bulk of the
storage bill.

Artifacts live in two places, because App Engine moved build storage from
Container Registry to Artifact Registry in March 2025:

| Store | Status |
| --- | --- |
| Artifact Registry `us-central1/gae-standard` | current, grows every deploy |
| GCS `us.artifacts.<project>.appspot.com` | legacy, frozen 2025-03-03 |

```bash
./scripts/prune_artifacts.sh                  # dry run
./scripts/prune_artifacts.sh --yes            # delete
./scripts/prune_artifacts.sh --legacy-bucket  # dry run against the old bucket
```

Keeps the image tagged `latest` plus the newest `--keep` (default 10) per
package, mirroring how `prune_versions.sh` keeps the serving version plus 10.

`--legacy-bucket` deletes the whole bucket rather than keeping N. Its contents
are content-addressed blobs whose Container Registry index no longer exists,
so they cannot be grouped into images, and images share layers — deleting a
subset by timestamp could corrupt whatever remains. It refuses to run if it
finds objects newer than 2025-04-01, which would mean the bucket is live again.