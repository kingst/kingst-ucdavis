from __future__ import print_function
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import re
import urllib
import requests
import sys

if len(sys.argv) != 3:
    print('Usage: {0} slide_url github_url'.format(sys.argv[0]))
    sys.exit(0)

# If modifying these scopes, delete the file token.json.
SCOPES = 'https://www.googleapis.com/auth/spreadsheets'


def main():
    """Shows basic usage of the Sheets API.
    Prints values from a sample spreadsheet.
    """
    store = file.Storage('token.json')
    creds = store.get()
    if not creds or creds.invalid:
        flow = client.flow_from_clientsecrets('credentials.json', SCOPES)
        creds = tools.run_flow(flow, store)
    service = build('sheets', 'v4', http=creds.authorize(Http()))

    # Call the Sheets API
    SPREADSHEET_ID = '1whfqnqc3TM8ui4hjLqCQq9ZVN5kMuTQrRodXvFreZxM'
    result = service.spreadsheets().get(spreadsheetId = SPREADSHEET_ID).execute()
    spreadsheetUrl = result['spreadsheetUrl']

    values = [['[<a href="{0}">Slides</a>][<a href="{1}">Source</a>]'.format(
                sys.argv[1], sys.argv[2])]]
    body = { 'values': values }
    range_name = 'C6'
    result = service.spreadsheets().values().update(
        spreadsheetId=SPREADSHEET_ID, range=range_name,
        valueInputOption='RAW', body=body).execute()
    print('{0} cells updated.'.format(result.get('updatedCells')))

if __name__ == '__main__':
    main()
