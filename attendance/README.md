# Attendance check-in

Spec: `attendance.md` in the repo root. Code: the attendance routes in
`main.py`. This folder holds the page students see, plus these notes.

## How it works

- `GET /apps/attendance/<token>` serves `index.html` as-is (no Jinja).
  The page remembers name and email in localStorage under the keys
  `attendance.name` and `attendance.email`.
- `POST /apps/attendance/<token>` takes form-encoded `name` and `email`,
  requires both, requires an `@ucdavis.edu` address (exactly that domain,
  not subdomains), and appends one row to the first tab of the sheet:
  `timestamp, token, name, email`. The timestamp is server time in
  America/Los_Angeles as ISO 8601, e.g. `2026-10-01T14:03:22-07:00`.
- Tokens are not validated. Anything after `/apps/attendance/` is
  accepted and recorded as the token.
- Names and emails are never logged. The sheet is the only place they go.

The server writes to Sheets as the App Engine default service account,
`kingst-ucd@appspot.gserviceaccount.com`, through Application Default
Credentials. There are no key files anywhere.

## One-time setup

1. Create the spreadsheet in your UC Davis Google account. Put a header
   row in the first tab: `Timestamp | Token | Name | Email`. New rows
   are appended below whatever is already there.
2. Share it with `kingst-ucd@appspot.gserviceaccount.com` as Editor.
   If the Workspace sharing dialog refuses an outside account, that is a
   campus policy and we need a different approach.
3. The Sheets API is already enabled on project `kingst-ucd` (checked
   2026-10-01). If it ever isn't:
   `gcloud services enable sheets.googleapis.com --project=kingst-ucd`
4. Put the sheet's ID (the long string in its URL) in `app.yaml`:

   ```yaml
   env_variables:
     ATTENDANCE_SPREADSHEET_ID: "..."
   ```

   The ID is in the public repo on purpose, to keep deploys simple. It
   grants no access on its own: only accounts the sheet is shared with
   can read or write it.

## Testing locally

```bash
gcloud auth application-default login \
  --scopes=https://www.googleapis.com/auth/spreadsheets,https://www.googleapis.com/auth/cloud-platform
ATTENDANCE_SPREADSHEET_ID=<id> venv/bin/python main.py
```

Then open <http://localhost:8080/apps/attendance/test> and check in. A
row should appear in the sheet. This path uses your own account rather
than the service account, so it proves the code but not the sharing in
step 2. The `--scopes` flag matters: a default ADC login can't touch
Sheets.

Without credentials the page still renders, and a POST answers 500 with
a JSON error. That is the expected failure mode.

## If check-ins return 500

Search the App Engine logs for `attendance: could not append`:

- `403 ... The caller does not have permission`: the sheet isn't shared
  with the service account (step 2).
- `403 ... has not been used in project` or similar: the API is
  disabled (step 3).
- `ATTENDANCE_SPREADSHEET_ID is not set`: the `env_variables` block
  was dropped from `app.yaml` (step 4).
- `insufficient authentication scopes`: `SHEETS_SCOPES` in `main.py`
  is no longer reaching `google.auth.default`.
