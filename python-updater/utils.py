import content  # My own files of strings

def to_megabytes(bytes):
    '''
    Returns the amount of bytes formatted into MB
    :param bytes:
    :return:
    '''
    return bytes / (1024 * 1024)

def colorize(text, tag):
    '''
    Colorizes a text to be shown in a terminal
    :param text: The text to be shown
    :param tag: Which tag shall we use (see content.py for more)
    :return: The text with the color tag
    '''
    return content.color[tag] + text + content.color['END_C']