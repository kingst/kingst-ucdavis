import csv
import jinja2
import json
import os
import sys
import webapp2

reload(sys)
sys.setdefaultencoding('utf-8')

JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)


class W18Ecs188(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        template = JINJA_ENVIRONMENT.get_template('classes/w18-ecs188/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes and reports'},
               {'page': 'final_paper.html', 'label': 'Final paper'},
               {'page': 'presentations.html', 'label': 'Presentations'}]
        self.response.write(template.render({'nav_title': 'ECS 188',
                                             'page': page,
                                             'nav': nav}))


class W18Ecs251(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/w18-ecs251/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/w18-ecs251/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Research project'},
               {'page': 'presentations.html', 'label': 'Presentations'}]
        self.response.write(template.render({'nav_title': 'ECS 251',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))


class Home(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'teaching.html'

        template = JINJA_ENVIRONMENT.get_template('home/' + page)
        classes = [{'title': 'ECS 251',
                    'quarter': 'Winter 18',
                    'page': '/classes/w18-ecs251/index.html'},
                   {'title': 'ECS 188',
                    'quarter': 'Winter 18',
                    'page': '/classes/w18-ecs188/index.html'}]
        nav = [{'page': '/', 'label': 'Home'},
               {'page': '/', 'label': 'Research'},
               {'page': 'teaching.html', 'label': 'Teaching'}]
        self.response.write(template.render({'classes': classes,
                                             'nav_title': 'Sam King',
                                             'nav': nav,
                                             'page': page}))


app = webapp2.WSGIApplication(
    [(r'/classes/w18-ecs188/(.*)', W18Ecs188),
     (r'/classes/w18-ecs251/(.*)', W18Ecs251),
     (r'/(.*)', Home)],
     debug=False)


def main():
    # E0602:158,4:main: Undefined variable 'run_wsgi_app'
    run_wsgi_app(app) # pylint: disable=E0602


if __name__ == "__main__":
    main()
