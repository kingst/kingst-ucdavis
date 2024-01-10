import csv
import sys

from dateutil.parser import parse

def main(today_string, reading_list, slides_url, github_url):
    today = parse(today_string)

    fieldnames = None
    csv_data = []
    
    with open(reading_list) as csvfile:
        reader = csv.DictReader(csvfile)
        fieldnames = reader.fieldnames
    
        for row in reader:
            lecture_date = parse(row['date'])
            if today == lecture_date:
                row['slides'] = f'[<a href="{slides_url}">Slides</a>]'
                if github_url:
                    row['slides'] += f' [<a href="{github_url}">Source</a>]'
            csv_data.append(row)

    with open(reading_list, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for row in csv_data:
            writer.writerow(row)

if __name__ == '__main__':
    if len(sys.argv) == 4:
        main(sys.argv[1], sys.argv[2], sys.argv[3], None)
    elif len(sys.argv) == 5:
        main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
    else:
        print(f'Usage {sys.argv[0]}: today_string, reading_list, slides_url, github_url')
        sys.exit(0)
