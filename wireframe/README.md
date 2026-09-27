> Exported from git@github.com:kingst/Wireframe.git at commit 74f4181 on 2026-09-27.
> Don't edit this folder: the next export replaces it.

# Integrating Wireframe into another app

Wireframe runs entirely in the browser, and the whole app is one
self-contained HTML file (JS, CSS and fonts inlined). Hosting it means
serving that file at whatever URL you like. There are no other assets,
no server-side code, no database, and no server-side state.

## What you get

```
wireframe/
  index.html       # the whole app (~540 KB, ~260 KB gzipped)
  README.md        # this doc, plus where and when it was exported
```

## Steps

### 1. Export

From the Wireframe source repo (needs Node and `npm install` in
`frontend/` once):

```
scripts/export.sh /path/to/host-app
```

This builds the app and writes `/path/to/host-app/wireframe/`,
replacing what was there. Commit that folder in the host app: its
deploy then needs no Node. To put the folder somewhere else, export to
that directory instead (for example `scripts/export.sh host-app/static`).

### 2. Serve `index.html` at any URL

Any URL works, with or without a trailing slash, because the file
loads nothing else. Some examples, mounting at `/apps/wireframe`:

**Flask:**

```python
from pathlib import Path
from flask import send_from_directory

WIREFRAME = Path(__file__).parent / "wireframe"

@app.get("/apps/wireframe")
def wireframe():
    return send_from_directory(WIREFRAME, "index.html")
```

**App Engine `app.yaml`** (static handler, no Flask involved; put it
above any catch-all handler):

```yaml
handlers:
  - url: /apps/wireframe
    static_files: wireframe/index.html
    upload: wireframe/index\.html
    secure: always
```

Anything that serves a file works the same way (nginx, a CDN bucket,
GitHub Pages).

## Things to know

- **Designs are stored in the browser** (IndexedDB), keyed by origin.
  They stay on the user's machine, and they don't move when the app's
  domain changes: users carry designs over with JSON export/import.
- **Same-origin storage.** Wireframe shares the host's origin, so it
  shares IndexedDB and localStorage with the host app. Wireframe uses
  the IndexedDB database `wireframe` and localStorage keys starting
  with `wireframe.`. Avoid those names in the host app.
- **Content-Security-Policy.** The JS and CSS are inline, so a host
  with a strict CSP needs, for this page: `script-src 'unsafe-inline'`,
  `style-src 'unsafe-inline'`, `font-src data:`, `connect-src data:`
  (fonts are embedded as `data:` URLs), and `img-src data:` (PNG
  export). Hosts without a CSP need nothing.
- **Provenance.** The first lines of `index.html` include a comment
  with the source commit and export date.

## Updating

From the Wireframe source repo, re-run `scripts/export.sh` against the
host app and commit the result. Don't edit the exported folder by
hand: the next export replaces it.
