from __future__ import print_function
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import csv
import re
import urllib
import requests
import sys

# If modifying these scopes, delete the file token.json.
SCOPES = 'https://www.googleapis.com/auth/spreadsheets.readonly'


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

    if len(sys.argv) != 2:
        print('Usage: {0} out_file.csv'.format(sys.argv[0]))
        sys.exit(0)
    
    # Call the Sheets API
    SPREADSHEET_ID = '14DFp5B5zfdZpieLyHl1hY8KQ_CF_Bzj4eDixqRfVNbY'
    rangeValues = 'A1:G30'
    result = service.spreadsheets().values().get(spreadsheetId = SPREADSHEET_ID, range=rangeValues).execute()

    with open(sys.argv[1], 'w') as csvFile:
        writer = csv.writer(csvFile)
        for row in result['values']:
            writer.writerow(row)


if __name__ == '__main__':
    main()
