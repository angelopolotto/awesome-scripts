#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import logging
import os

# Refs.
# https://codecalamity.com/uploading-large-files-by-chunking-featuring-python-flask-and-dropzone-js/
# https://docs.python.org/3/howto/logging-cookbook.html

from flask import Flask, render_template, Blueprint, request, make_response
from werkzeug.utils import secure_filename

app = Flask(__name__, template_folder='./templates', static_folder='./templates/assets')

path = os.path.dirname(__file__)

data_dir = os.path.join(path, './uploads')

logger = logging.getLogger('simple_example')
logger.setLevel(logging.DEBUG)
# create file handler which logs even debug messages
fh = logging.FileHandler('spam.log')
fh.setLevel(logging.DEBUG)
# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
# create formatter and add it to the handlers
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
ch.setFormatter(formatter)
fh.setFormatter(formatter)
# add the handlers to logger
logger.addHandler(ch)
logger.addHandler(fh)

@app.route('/')
@app.route('/index')
def index():
    # Route to serve the upload form
    return render_template('index.html',
                           page_name='Main',
                           project_name="pydrop")


@app.route('/upload', methods=['POST'])
def upload():
    # Route to deal with the uploaded chunks
    # debug only
    # logger.info(request.form)
    # logger.info(request.files)

    file = request.files['file']

    save_path = os.path.join(data_dir, secure_filename(file.filename))
    current_chunk = int(request.form['dzchunkindex'])

    # If the file already exists it's ok if we are appending to it,
    # but not if it's new file that would overwrite the existing one
    if os.path.exists(save_path) and current_chunk == 0:
        # 400 and 500s will tell dropzone that an error occurred and show an error
        return make_response(('File already exists', 400))

    try:
        with open(save_path, 'ab') as f:
            f.seek(int(request.form['dzchunkbyteoffset']))
            f.write(file.stream.read())
    except OSError:
        # log.exception will include the traceback so we can see what's wrong 
        logger.exception('Could not write to file')
        return make_response(("Not sure why,"
                              " but we couldn't write the file to disk", 500))

    total_chunks = int(request.form['dztotalchunkcount'])

    if current_chunk + 1 == total_chunks:
        # This was the last chunk, the file should be complete and the size we expect
        if os.path.getsize(save_path) != int(request.form['dztotalfilesize']):
            logger.error(f"File {file.filename} was completed, "
                      f"but has a size mismatch."
                      f"Was {os.path.getsize(save_path)} but we"
                      f" expected {request.form['dztotalfilesize']} ")
            return make_response(('Size mismatch', 500))
        else:
            logger.info(f'File {file.filename} has been uploaded successfully')
    else:
        logger.debug(f'Chunk {current_chunk + 1} of {total_chunks} '
                  f'for file {file.filename} complete')

    return make_response(("Chunk upload successful", 200))

if __name__ == '__main__':
	app.run(debug=False, host='0.0.0.0', port=8080)