from __future__ import print_function
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import re
import urllib
import requests
import sys


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

    if len(sys.argv) != 3 and len(sys.argv) != 4:
        print('Usage: {0} slide_url video_url [source_url]'.format(sys.argv[0]))
        sys.exit(0)
    
    # Call the Sheets API
    SPREADSHEET_ID = '14DFp5B5zfdZpieLyHl1hY8KQ_CF_Bzj4eDixqRfVNbY'
    result = service.spreadsheets().get(spreadsheetId = SPREADSHEET_ID).execute()
    spreadsheetUrl = result['spreadsheetUrl']

    if len(sys.argv) == 3:
        values = [['[<a href="{0}">Slides</a>] [<a href="{1}">Video</a>]'.format(sys.argv[1], sys.argv[2])]]
    else:
        values = [['[<a href="{0}">Slides</a>] [<a href="{1}">Video</a>] [<a href="{2}">Source</a>]'.format(sys.argv[1], sys.argv[2], sys.argv[3])]]
    body = { 'values': values }

    col = 'C'
    row = 1
    range_name = '{0}{1}'.format(col, row)
    result = service.spreadsheets().values().get(
        spreadsheetId=SPREADSHEET_ID,
        range=range_name).execute()
    while len(result.get('values', [['']])[0][0]) != 0:
        row += 1
        range_name = '{0}{1}'.format(col, row)
        result = service.spreadsheets().values().get(
            spreadsheetId=SPREADSHEET_ID,
            range=range_name).execute()

    result = service.spreadsheets().values().update(
        spreadsheetId=SPREADSHEET_ID, range=range_name,
        valueInputOption='RAW', body=body).execute()
    print('{0} cells updated.'.format(result.get('updatedCells')))


if __name__ == '__main__':
    main()
