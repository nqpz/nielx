def get_extension(filename):
    try:
        return filename.rsplit('.', 1)[1].lower()
    except IndexError:
        return None

def get_basename(filename):
    return filename.rsplit('.', 1)[0]
