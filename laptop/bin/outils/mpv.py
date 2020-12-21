from outils import *

_media_endings = ['mkv', 'mp4', 'webm', 'ogg', 'ogv', 'mp3', 'm2t', 'flac', 'avi', 'mpg', 'mts', 'mov', 'wav']

def open(filenames):
    first = filenames[0]
    ext = get_extension(first)
    if ext in _media_endings:
        return ['mpv'] + filenames
