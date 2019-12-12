#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import logging
import os

from flask import Flask, render_template, Blueprint, request, make_response
from werkzeug.utils import secure_filename

app = Flask(__name__)

path = os.path.dirname(__file__)

template_folder = os.path.join(path, './templates')

print(template_folder)

blueprint = Blueprint('templated', __name__, template_folder=template_folder)

log = logging.getLogger('pydrop')

@blueprint.route('/')
@blueprint.route('/index')
def index():
    # Route to serve the upload form
    return render_template('index.html',
                           page_name='Main',
                           project_name="pydrop")


@blueprint.route('/upload', methods=['POST'])
def upload():
    # Route to deal with the uploaded chunks
    log.info(request.form)
    log.info(request.files)
    return make_response(('ok', 200))

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0', port=8080)