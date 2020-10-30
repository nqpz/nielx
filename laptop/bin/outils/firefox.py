from outils import *

_media_endings = ['html', 'htm']

def open(filenames):
    first = filenames[0]
    ext = get_extension(first)
    if ext in _media_endings:
        return ['firefox'] + filenames
