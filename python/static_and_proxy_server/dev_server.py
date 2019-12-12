# Refs:
# proxy pass flask
# https://medium.com/@zwork101/making-a-flask-proxy-server-online-in-10-lines-of-code-44b8721bca6
# https://stackoverflow.com/questions/15117416/capture-arbitrary-path-in-flask-route
# https://stackoverflow.com/questions/7164679/how-to-send-cookies-in-a-post-request-with-the-python-requests-library
# https://stackoverflow.com/questions/42018603/handling-get-and-post-in-same-flask-view
# https://stackoverflow.com/questions/20646822/how-to-serve-static-files-in-flask
# https://github.com/lepture/python-livereload
# https://stackoverflow.com/questions/22736481/ignoring-files-with-watchdog

from flask import Flask, send_from_directory, redirect
from requests import get, post
import flask
import os

path = os.path.dirname(__file__)

API_URL = '/api/'
API_URL_PROXY = 'http://google.com/'

ASSETS_URL = '/static'
ASSETS_FOLDER = os.path.join(path, './static')
ASSETS_INDEX = '/static/index.html'

app = Flask('__main__', static_folder=ASSETS_FOLDER, static_url_path=ASSETS_URL)

@app.route('/')
def index():
  return redirect(ASSETS_INDEX)

@app.route(API_URL, defaults={'path': ''}, methods=['GET', 'POST'])
@app.route('/<path:path>', methods=['GET', 'POST'])
def api_proxy(path):
  print('path: ' + path)
  api_url_proxy = ''
  path2 = path.replace(API_URL[1:], '')
  api_url_proxy = f'{API_URL_PROXY}{path2}'
  
  print('--------------- api_proxy: ' + api_url_proxy)
  return proxy_request(api_url_proxy, flask.request.method)

def proxy_request(url, method):
  if method == 'GET':
    return get(url).content
  elif method == 'POST':
    return post(url).content

if __name__ == '__main__':
  app.run(debug=True, host='0.0.0.0', port=8080)