from outils import *

_media_endings = ['jpg', 'jpeg', 'png', 'bmp']

def open(filenames):
    first = filenames[0]
    ext = get_extension(first)
    if ext in _media_endings:
        return ['gpicview'] + filenames
    elif ext == 'gif':  # hack: use something else
        return ['animate', '-backdrop', '-loop', '0'] + filenames
    elif ext == 'svg':  # hack: use something else
        return ['inkview'] + filenames
