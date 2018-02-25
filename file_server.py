import cgi
import http
import mimetypes
import os
import shutil
import urllib.parse

STORAGE_PATH = os.environ.get('STORAGE_PATH') or \
               os.path.dirname(__file__) + '/storage'


class App(object):
    def __init__(self, debug=False, https_only=False):
        self.debug = debug
        self.https_only = https_only

    def path(self):
        return self.env.get('SCRIPT_NAME', '') + self.env.get('PATH_INFO', '')

    def url_params(self):
        return urllib.parse.parse_qs(self.env.get('QUERY_STRING', ''))

    def method(self):
        return self.env['REQUEST_METHOD']

    def is_post(self):
        return self.method() == 'POST'

    def form(self):
        return cgi.FieldStorage(
            fp=self.env['wsgi.input'],
            environ=self.env,
            keep_blank_values=True
        )

    def redirect(self, to, permanent=False, headers=None):
        return self.response(code=301 if permanent else 302,
                             headers=dict({'Location': to}, **(headers or {})))

    def response(self, code=200, content_type=None, headers=None, content=''):
        headers = dict({
            'Server': 'nginx',
        }, **(headers or {}))
        if content_type:
            headers['Content-Type'] = content_type
        if self.https_only:
            headers['Strict-Transport-Security'] = 'max-age=31536000'
        self._response('%d %s' % (code, http.HTTPStatus(code).phrase),
                       list(headers.items()))
        if hasattr(content, 'read'):
            block_size = 8196 * 4
            if 'wsgi.file_wrapper' in self.env:
                return self.env['wsgi.file_wrapper'](content, block_size)
            else:
                return iter(lambda: content.read(block_size), '')
        elif isinstance(content, str):
            return [content.encode()]
        elif isinstance(content, bytes):
            return [content]
        elif isinstance(content, list):
            return content
        raise NotImplementedError

    def is_https(self):
        return self.env['wsgi.url_scheme'] == 'https'

    def host(self):
        h = self.env.get('HTTP_HOST')
        if not h:
            h = self.env['SERVER_NAME']
            if self.env['SERVER_PORT'] != ('443' if self.is_https() else '80'):
                h += ':' + self.env['SERVER_PORT']
        return h

    def full_url(self, scheme=None):
        url = (scheme or self.env['wsgi.url_scheme']) + '://'
        url += self.host()
        url += urllib.parse.quote(self.path())
        qs = self.env.get('QUERY_STRING')
        if qs:
            url += '?' + qs
        return url

    def prepare_path(self, path):
        assert path, path
        assert '..' not in path, path
        assert '//' not in path, path
        assert not path.startswith('/'), path
        path = os.path.join(STORAGE_PATH, path)
        return path

    def __call__(self, env, response):
        self.env = env
        self._response = response

        if self.https_only and not self.is_https():
            return self.redirect(to=self.full_url(scheme='https'))

        if self.is_post():
            assert self.path() == '/', self.path()
            f = self.form()
            path = self.prepare_path(path=f.getfirst('path'))
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, 'wb+') as dst_fp:
                shutil.copyfileobj(f['file'].file, dst_fp)
            return self.response(200)

        path = self.prepare_path(self.path()[1:])
        if os.path.exists(path) and os.path.isfile(path):
            return self.response(200,
                                 content_type=mimetypes.guess_type(path)[0],
                                 content=open(path, 'rb'))

        return self.response(404)


debug = bool(os.environ.get('DEBUG'))
app = App(debug=debug, https_only=not debug)


if __name__ == '__main__':
    from wsgiref.simple_server import make_server
    from wsgiref.handlers import BaseHandler
    BaseHandler.error_body = b''
    try:
        host = os.environ.get('HOST') or '127.0.0.1'
        host, _, port = host.partition(':')
        port = int(port or os.environ.get('PORT') or 8000)
        print('Starting server %s:%s...' % (host, port))
        make_server(host=host, port=port, app=app).serve_forever()
    except KeyboardInterrupt:
        print('\nStopped.')
