import csv
import os
import re
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo
import google.auth
from flask import Flask, abort, jsonify, render_template, request, send_from_directory
from googleapiclient.discovery import build
from jinja2 import TemplateNotFound

app = Flask(__name__, template_folder='.', static_folder='assets', static_url_path='/assets')

WIREFRAME = Path(__file__).parent / 'wireframe'

def render_page(template_name, **context):
    # Unknown URLs map to templates that don't exist: answer 404, not 500.
    # Only the page itself counts; a missing include is still a real error.
    try:
        return render_template(template_name, **context)
    except TemplateNotFound as e:
        if e.name == template_name:
            abort(404)
        raise


def read_csv(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        return list(reader)


def nav_for_class(class_name):
    if class_name == 's18-ecs188':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes and reports'},
               {'page': 'final_paper.html', 'label': 'Final paper'},
               {'page': 'presentations.html', 'label': 'Presentations'}]
    elif class_name == 's21-ecs150':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Midterms'},
               {'page': 'project.html', 'label': 'Project'}]
    elif class_name == 's24-ecs150':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Midterms'},
               {'page': 'project.html', 'label': 'Project'}]
    elif class_name == 'f24-ecs150':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Midterms'},
               {'page': 'project.html', 'label': 'Project'}]
    elif class_name == 'w25-ecs150':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Midterms'},
               {'page': 'project.html', 'label': 'Project'}]
    elif class_name == 's26-ecs150':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Midterms'},
               {'page': 'project.html', 'label': 'Project'}]
    elif class_name == 'w18-ecs188':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes and reports'},
               {'page': 'final_paper.html', 'label': 'Final paper'},
               {'page': 'presentations.html', 'label': 'Presentations'}]
    elif class_name == 'f18-ecs189e':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
    elif class_name == 'f19-ecs189e':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
    elif class_name == 'w21-ecs189e':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
    elif class_name == 'w24-ecs189e':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
    elif class_name == 'w26-ecs191':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
    elif class_name == 'f26-ecs191':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
    elif class_name == 'w18-ecs251':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Research project'},
               {'page': 'presentations.html', 'label': 'Presentations'}]
    elif class_name == 'w19-ecs251':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Research project'},
               {'page': 'homework.html', 'label': 'Homework'}]
    elif class_name == 'w20-ecs251':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Research project'},
               {'page': 'presentations.html', 'label': 'Lead a lecture'}]
    elif class_name == 's19-ecs153':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
    elif class_name == 's20-ecs153':
        return [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Project'},
               {'page': 'remote.html', 'label': 'Remote project'},
               {'page': 'homework.html', 'label': 'Homework'}]


@app.route('/classes/<class_name>/<page>')
def render_class_page(class_name, page):
    if not page or len(page) == 0:
        page = 'index.html'

    try:
        reading_list = read_csv(f'classes/{class_name}/reading_list.csv')
    except FileNotFoundError:
        abort(404)

    nav = nav_for_class(class_name)
    
    return render_page(f'classes/{class_name}/{page}',
                       nav_title=class_name.upper(),
                       page=page,
                       nav=nav,
                       reading_list=reading_list)


@app.route('/', defaults={'path': 'main.html'})
@app.route('/<path:path>')
def home(path):
    page = path
    publication_list = read_csv('home/publications.csv')

    def publication_to_listing(publication):
        if publication['paper'].startswith('https://'):
            url = publication['paper']
        else:
            url = '/assets/dl/' + publication['paper']
        anchor = f'<a href="{url}">'
        end_anchor = '</a>'
        return publication['publication'].replace('{start_title}', anchor).replace('{end_title}', end_anchor)

    publications = [publication_to_listing(x) for x in publication_list]

    classes = [
        {'title': 'ECS 191', 'quarter': 'Fall 26', 'page': '/classes/f26-ecs191/index.html'}
    ]

    past_classes = [
        {'title': 'ECS 150', 'quarter': 'Spring 26', 'page': '/classes/s26-ecs150/index.html'},
        {'title': 'ECS 191', 'quarter': 'Winter 26', 'page': '/classes/w26-ecs191/index.html'},
        {'title': 'ECS 150', 'quarter': 'Winter 25', 'page': '/classes/w25-ecs150/index.html'},
        {'title': 'ECS 150', 'quarter': 'Fall 24', 'page': '/classes/f24-ecs150/index.html'},
        {'title': 'ECS 150', 'quarter': 'Spring 24', 'page': '/classes/s24-ecs150/index.html'},
        {'title': 'ECS 189e', 'quarter': 'Winter 24', 'page': '/classes/w24-ecs189e/index.html'},
        {'title': 'ECS 150', 'quarter': 'Spring 21', 'page': '/classes/s21-ecs150/index.html'},
        {'title': 'ECS 189e', 'quarter': 'Winter 21', 'page': '/classes/w21-ecs189e/index.html'},
        {'title': 'ECS 153', 'quarter': 'Spring 20', 'page': '/classes/s20-ecs153/index.html'},
        {'title': 'ECS 251', 'quarter': 'Winter 20', 'page': '/classes/w20-ecs251/index.html'},
        {'title': 'ECS 189e', 'quarter': 'Fall 19', 'page': '/classes/f19-ecs189e/index.html'},
        {'title': 'ECS 153', 'quarter': 'Spring 19', 'page': '/classes/s19-ecs153/index.html'},
        {'title': 'ECS 251', 'quarter': 'Winter 19', 'page': '/classes/w19-ecs251/index.html'},
        {'title': 'ECS 189e', 'quarter': 'Fall 18', 'page': '/classes/f18-ecs189e/index.html'},
        {'title': 'ECS 188', 'quarter': 'Spring 18', 'page': '/classes/s18-ecs188/index.html'},
        {'title': 'ECS 251', 'quarter': 'Winter 18', 'page': '/classes/w18-ecs251/index.html'},
        {'title': 'ECS 188', 'quarter': 'Winter 18', 'page': '/classes/w18-ecs188/index.html'}
    ]

    nav = [
        {'page': '/', 'label': 'Home'},
        {'page': 'research.html', 'label': 'Research'},
        {'page': 'publications.html', 'label': 'Publications'},
        {'page': 'teaching.html', 'label': 'Teaching'}
    ]

    return render_page('home/' + page,
                       classes=classes,
                       past_classes=past_classes,
                       publications=publications,
                       nav_title='Sam King',
                       nav=nav,
                       page=page)

# Wireframe is a self-contained app exported from github.com/kingst/Wireframe.
# Serve the file as-is: render_template would run it through Jinja.
@app.route('/apps/wireframe')
@app.route('/apps/wireframe/')
def wireframe():
    return send_from_directory(WIREFRAME, 'index.html')

# Attendance check-in. Spec: attendance.md. Setup notes: attendance/README.md.
# Tokens are not validated, only recorded; the sheet is the only place the
# name and email go, so they must never end up in the logs.
ATTENDANCE = Path(__file__).parent / 'attendance'
ATTENDANCE_TZ = ZoneInfo('America/Los_Angeles')
SHEETS_SCOPES = ['https://www.googleapis.com/auth/spreadsheets']
UCD_EMAIL = re.compile(r'^[a-z0-9._%+-]+@ucdavis\.edu$')
MAX_FIELD_LEN = 200


def append_attendance_row(row):
    spreadsheet_id = os.environ.get('ATTENDANCE_SPREADSHEET_ID')
    if not spreadsheet_id:
        raise RuntimeError('ATTENDANCE_SPREADSHEET_ID is not set')
    # On App Engine this is the app's default service account, so the sheet
    # has to be shared with it. Locally it is whatever ADC is logged in as.
    credentials, _ = google.auth.default(scopes=SHEETS_SCOPES)
    sheets = build('sheets', 'v4', credentials=credentials, cache_discovery=False)
    # RAW keeps the strings as typed, so "=1+1" in a name stays text rather
    # than becoming a formula. A range with no tab name means the first tab.
    sheets.spreadsheets().values().append(
        spreadsheetId=spreadsheet_id,
        range='A:D',
        valueInputOption='RAW',
        insertDataOption='INSERT_ROWS',
        body={'values': [row]}).execute()


@app.route('/apps/attendance/<token>', methods=['GET'])
def attendance_page(token):
    # Served as-is like wireframe: the page has no template variables and
    # its JavaScript would trip over Jinja.
    return send_from_directory(ATTENDANCE, 'index.html')


@app.route('/apps/attendance/<token>', methods=['POST'])
def attendance_submit(token):
    name = request.form.get('name', '').strip()
    email = request.form.get('email', '').strip().lower()
    if not name or not email:
        return jsonify(ok=False, error='Please fill in both your name and your email.'), 400
    if len(name) > MAX_FIELD_LEN or len(email) > MAX_FIELD_LEN:
        return jsonify(ok=False, error='That name or email is too long.'), 400
    if not UCD_EMAIL.match(email):
        return jsonify(ok=False, error='Please use your @ucdavis.edu email address.'), 400

    timestamp = datetime.now(ATTENDANCE_TZ).isoformat(timespec='seconds')
    try:
        append_attendance_row([timestamp, token, name, email])
    except Exception:
        app.logger.exception('attendance: could not append to the sheet')
        return jsonify(ok=False, error='Could not record your attendance. Please try again.'), 500
    return jsonify(ok=True)


@app.route('/robots.txt')
def robots_txt():
    return "User-agent: *\nDisallow:"

if __name__ == "__main__":
    app.run(debug=True, port=8080)

