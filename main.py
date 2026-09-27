import csv
import os
from pathlib import Path
from flask import Flask, abort, render_template, request, send_from_directory
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

@app.route('/robots.txt')
def robots_txt():
    return "User-agent: *\nDisallow:"

if __name__ == "__main__":
    app.run(debug=True, port=8080)

