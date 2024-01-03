import csv
import os
from flask import Flask, render_template, request

app = Flask(__name__, template_folder='.', static_folder='assets', static_url_path='/assets')

def read_csv(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        return list(reader)

@app.route('/classes/<class_name>/<page>')
def render_class_page(class_name, page):
    if not page or len(page) == 0:
        page = 'index.html'

    reading_list = read_csv(f'classes/{class_name}/reading_list.csv')

    return render_template(f'classes/{class_name}/{page}',
                           nav_title=class_name.upper(),
                           page=page,
                           nav=[
                               {'page': 'index.html', 'label': 'Home'},
                               {'page': 'grading.html', 'label': 'Grading'},
                               {'page': 'lectures.html', 'label': 'Lectures'},
                               {'page': 'quizzes.html', 'label': 'Quizzes and reports'},
                               {'page': 'final_paper.html', 'label': 'Final paper'},
                               {'page': 'presentations.html', 'label': 'Presentations'}
                           ],
                           reading_list=reading_list)


@app.route('/', defaults={'path': 'main.html'})
@app.route('/<path:path>')
def home(path):
    page = path
    publication_list = read_csv('home/publications.csv')

    def publication_to_listing(publication):
        url = '/assets/dl/' + publication['paper']
        anchor = f'<a href="{url}">'
        end_anchor = '</a>'
        return publication['publication'].replace('{start_title}', anchor).replace('{end_title}', end_anchor)

    publications = [publication_to_listing(x) for x in publication_list]

    classes = [
        {'title': 'ECS 189e', 'quarter': 'Winter 24', 'page': '/classes/w24-ecs189e/index.html'}
    ]

    past_classes = [
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

    return render_template('home/' + page,
                           classes=classes,
                           past_classes=past_classes,
                           publications=publications,
                           nav_title='Sam King',
                           nav=nav,
                           page=page)

@app.route('/robots.txt')
def robots_txt():
    return "User-agent: *\nDisallow:"

if __name__ == "__main__":
    app.run(debug=True)

