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

class S18Ecs188(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/s18-ecs188/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/s18-ecs188/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes and reports'},
               {'page': 'final_paper.html', 'label': 'Final paper'},
               {'page': 'presentations.html', 'label': 'Presentations'}]
        self.response.write(template.render({'nav_title': 'ECS 188',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))

class S21Ecs150(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/s21-ecs150/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/s21-ecs150/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Midterms'},
               {'page': 'project.html', 'label': 'Project'}]
        self.response.write(template.render({'nav_title': 'ECS 150',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))


class W18Ecs188(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/w18-ecs188/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/w18-ecs188/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes and reports'},
               {'page': 'final_paper.html', 'label': 'Final paper'},
               {'page': 'presentations.html', 'label': 'Presentations'}]
        self.response.write(template.render({'nav_title': 'ECS 188',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))



class F18Ecs189e(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/f18-ecs189e/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/f18-ecs189e/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
        self.response.write(template.render({'nav_title': 'ECS 189e',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))


class F19Ecs189e(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/f19-ecs189e/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/f19-ecs189e/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
        self.response.write(template.render({'nav_title': 'ECS 189e',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))


class W21Ecs189e(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/w21-ecs189e/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/w21-ecs189e/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
        self.response.write(template.render({'nav_title': 'ECS 189e',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))

class W24Ecs189e(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/w24-ecs189e/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/w24-ecs189e/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
        self.response.write(template.render({'nav_title': 'ECS 189e',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))


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


class W19Ecs251(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/w19-ecs251/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/w19-ecs251/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Research project'},
               {'page': 'homework.html', 'label': 'Homework'}]
        self.response.write(template.render({'nav_title': 'ECS 251',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))

        
class W20Ecs251(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/w20-ecs251/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/w20-ecs251/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Research project'},
               {'page': 'presentations.html', 'label': 'Lead a lecture'}]
        self.response.write(template.render({'nav_title': 'ECS 251',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))

class S19Ecs153(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/s19-ecs153/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/s19-ecs153/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Project'},
               {'page': 'homework.html', 'label': 'Homework'}]
        self.response.write(template.render({'nav_title': 'ECS 153',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))


class S20Ecs153(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'index.html'

        reading_list = csv.DictReader(open('classes/s20-ecs153/reading_list.csv'))

        template = JINJA_ENVIRONMENT.get_template('classes/s20-ecs153/' + page)
        nav = [{'page': 'index.html', 'label': 'Home'},
               {'page': 'grading.html', 'label': 'Grading'},
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'research_project.html', 'label': 'Project'},
               {'page': 'remote.html', 'label': 'Remote project'},
               {'page': 'homework.html', 'label': 'Homework'}]
        self.response.write(template.render({'nav_title': 'ECS 153',
                                             'page': page,
                                             'nav': nav,
                                             'reading_list': reading_list}))


class Home(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'main.html'

        publication_list = csv.DictReader(open('home/publications.csv'))

        def publication_to_listing(publication):
            url = '/assets/dl/' + publication['paper']
            anchor = '<a href="' + url + '">'
            end_anchor = '</a>'
            return publication['publication'].replace('{start_title}', anchor).replace('{end_title}', end_anchor)

        publications = [publication_to_listing(x) for x in publication_list]

        template = JINJA_ENVIRONMENT.get_template('home/' + page)
        classes = [{'title': 'ECS 189e',
                    'quarter': 'Winter 24',
                    'page': '/classes/w24-ecs189e/index.html'}]
        past_classes = [{'title': 'ECS 150',
                         'quarter': 'Spring 21',
                         'page': '/classes/s21-ecs150/index.html'},
                        {'title': 'ECS 189e',
                         'quarter': 'Winter 21',
                         'page': '/classes/w21-ecs189e/index.html'},
                        {'title': 'ECS 153',
                         'quarter': 'Spring 20',
                         'page': '/classes/s20-ecs153/index.html'},
                        {'title': 'ECS 251',
                         'quarter': 'Winter 20',
                         'page': '/classes/w20-ecs251/index.html'},
                        {'title': 'ECS 189e',
                         'quarter': 'Fall 19',
                         'page': '/classes/f19-ecs189e/index.html'},
                        {'title': 'ECS 153',
                    'quarter': 'Spring 19',
                    'page': '/classes/s19-ecs153/index.html'},
                        {'title': 'ECS 251',
                    'quarter': 'Winter 19',
                    'page': '/classes/w19-ecs251/index.html'},
                   {'title': 'ECS 189e',
                    'quarter': 'Fall 18',
                    'page': '/classes/f18-ecs189e/index.html'},
                        {'title': 'ECS 188',
                    'quarter': 'Spring 18',
                    'page': '/classes/s18-ecs188/index.html'},
                   {'title': 'ECS 251',
                    'quarter': 'Winter 18',
                    'page': '/classes/w18-ecs251/index.html'},
                   {'title': 'ECS 188',
                    'quarter': 'Winter 18',
                    'page': '/classes/w18-ecs188/index.html'}]
        nav = [{'page': '/', 'label': 'Home'},
               {'page': 'research.html', 'label': 'Research'},
               {'page': 'publications.html', 'label': 'Publications'},
               {'page': 'teaching.html', 'label': 'Teaching'}]
        self.response.write(template.render({'classes': classes,
                                             'past_classes': past_classes,
                                             'publications': publications,
                                             'nav_title': 'Sam King',
                                             'nav': nav,
                                             'page': page}))


class RobotsAll(webapp2.RequestHandler):
    def get(self):
        robots_txt_content = "User-agent: *\nDisallow:"
        self.response.headers['Content-Type'] = 'text/plain'
        self.response.write(robots_txt_content)        
        

app = webapp2.WSGIApplication(
    [(r'/classes/f18-ecs189e/(.*)', F18Ecs189e),
     (r'/classes/f19-ecs189e/(.*)', F19Ecs189e),
     (r'/classes/w21-ecs189e/(.*)', W21Ecs189e),
     (r'/classes/w24-ecs189e/(.*)', W24Ecs189e),
     (r'/classes/w18-ecs188/(.*)', W18Ecs188),
     (r'/classes/s18-ecs188/(.*)', S18Ecs188),
     (r'/classes/w18-ecs251/(.*)', W18Ecs251),
     (r'/classes/w19-ecs251/(.*)', W19Ecs251),
     (r'/classes/w20-ecs251/(.*)', W20Ecs251),
     (r'/classes/s19-ecs153/(.*)', S19Ecs153),
     (r'/classes/s20-ecs153/(.*)', S20Ecs153),
     (r'/classes/s21-ecs150/(.*)', S21Ecs150),
     (r'/robots.txt', RobotsAll),
     (r'/(.*)', Home)],
     debug=False)


def main():
    # E0602:158,4:main: Undefined variable 'run_wsgi_app'
    run_wsgi_app(app) # pylint: disable=E0602


if __name__ == "__main__":
    main()
