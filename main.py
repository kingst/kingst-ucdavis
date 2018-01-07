import os
import jinja2
import webapp2

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
               {'page': 'lectures.html', 'label': 'Lectures'},
               {'page': 'quizzes.html', 'label': 'Quizzes'},
               {'page': 'final_paper.html', 'label': 'Final paper'},
               {'page': 'final_presentation.html', 'label': 'Final presentation'}]
        self.response.write(template.render({'nav_title': 'ECS 188',
                                             'page': page,
                                             'nav': nav}))

class Home(webapp2.RequestHandler):
    def get(self, page):
        if page is None or len(page) == 0:
            page = 'teaching.html'

        template = JINJA_ENVIRONMENT.get_template('home/' + page)
        classes = [{'title': 'ECS 188', 'quarter': 'Winter 18', 'page': '/classes/w18-ecs188/index.html'}]
        nav = [{'page': '/', 'label': 'Home'},
               {'page': '/', 'label': 'Research'},
               {'page': 'teaching.html', 'label': 'Teaching'}]
        self.response.write(template.render({'classes': classes,
                                             'nav_title': 'Sam King',
                                             'nav': nav,
                                             'page': page}))


app = webapp2.WSGIApplication(
    [(r'/classes/w18-ecs188/(.*)', W18Ecs188),
     (r'/(.*)', Home)],
     debug=False)


def main():
    # E0602:158,4:main: Undefined variable 'run_wsgi_app'
    run_wsgi_app(app) # pylint: disable=E0602


if __name__ == "__main__":
    main()
