from __future__ import print_function
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import re
import urllib
import requests
import sys

if len(sys.argv) != 2:
    print('Usage: {0} out_file.csv'.format(sys.argv[0]))
    sys.exit(0)

# If modifying these scopes, delete the file token.json.
SCOPES = 'https://www.googleapis.com/auth/spreadsheets.readonly'

# The ID and range of a sample spreadsheet.
SAMPLE_SPREADSHEET_ID = '1AnVDk9A2ey3CtFI9tfSi2-avhxMEKDXH1G_YUyJAH9Q'
SAMPLE_RANGE_NAME = 'Class Data!A2:E'

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
    SPREADSHEET_ID = '1AnVDk9A2ey3CtFI9tfSi2-avhxMEKDXH1G_YUyJAH9Q'
    result = service.spreadsheets().get(spreadsheetId = SPREADSHEET_ID).execute()
    spreadsheetUrl = result['spreadsheetUrl']

    exportUrl = re.sub("\/edit$", '/export', spreadsheetUrl)
    headers = { 'Authorization': 'Bearer ' + creds.access_token }
    params = { 'format': 'csv',
               'gid': 0 } 
    queryParams = urllib.parse.urlencode(params)
    url = exportUrl + '?' + queryParams
    response = requests.get(url, headers = headers)
    with open(sys.argv[1], 'wb') as csvFile:
        csvFile.write(response.content)

if __name__ == '__main__':
    main()
