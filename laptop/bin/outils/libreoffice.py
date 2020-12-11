from outils import *

_media_endings = ['odt', 'doc', 'docx', 'xls', 'xlsx', 'wp']

def open(filenames):
    first = filenames[0]
    ext = get_extension(first)
    if ext in _media_endings:
        return ['libreoffice', '--view'] + filenames
