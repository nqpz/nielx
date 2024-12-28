from outils import *

_media_endings = ['jpg', 'jpeg', 'png', 'bmp', 'webp', 'avif']

def open(filenames):
    first = filenames[0]
    ext = get_extension(first)
    if ext in _media_endings:
        return ['loupe'] + filenames
    elif ext == 'gif':  # hack: use something else
        return ['animate', '-backdrop', '-loop', '0'] + filenames
    elif ext == 'svg':  # hack: use something else
        return ['inkview'] + filenames
