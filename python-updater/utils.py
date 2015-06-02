# -*- coding: utf-8 -*-

# To check for sudo
import sys
import os
from fnmatch import fnmatch as _fnmatch  # To search for files
from subprocess import check_call as _check_call

# To move/copy/remove folders with files
import shutil
import stat

# To check for the system architecture and name
import platform
import struct

# Handlers for requests and JSON
import requests
import json

import content  # My own files of strings

def to_megabytes(bytes):
    """
    Returns the amount of bytes formatted into MB
    :param bytes:
    :return:The bytes converted into MB
    """
    return bytes / (1024 * 1024)

def colorize(text, tag):
    """
    Colorizes a text to be shown in a terminal
    :param text: The text to be shown
    :param tag: Which tag shall we use (see content.py for more)
    :return: The text with the color tag
    """
    return content.color[tag] + text + content.color['END_C']


def get_os():
    """
    Checks in what operative system is the user in.
    Exits the system if the OS is neither linux nor windows
    :return:
    """
    if sys.platform == "win32" or sys.platform == "cygwin":
        os = "Windows"

    elif sys.platform == "linux" or sys.platform == "linux2":
        os = "Linux"

    else:
        print content.warning["os"]
        sys.exit(content.error_codes['get_os'])

    return os


def check_architecture_x64(os):
    """
    Checks if the architecture of the OS is 32 or 64
    :param os: String with "Linux" or "Windows"
    :return: True if its x64, False otherwise
    """

    # Checks the architecture of the SO in Linux
    if os == "Linux":
        return struct.calcsize("P") * 8 == 64

    # Else in Windows
    elif os == "Windows":
        return platform.machine().endswith('64')

    print content.warning["os"]
    sys.exit(content.error_codes['check_architecture_x64'])


def uncompress_file(file_name, folder = 'temp'):
    """
    Uncompress a certain file inside a temporary directory by default
    :param file_name:
    :param folder:
    :return:
    """

    import zipfile

    file_compressed = open(file_name, 'rb')
    zipped = zipfile.ZipFile(file_compressed)

    zipped.extractall(folder)

    file_compressed.close()


def ask_for_sudo():
    """
    Asks for login as superuser (in Linux environments), to allow tasks that
    are otherwise forbidden.
    :return:True in success while login as super user, False otherwise
    """

    # If it's already logged as sudo
    if os.geteuid() == 0:
        return True

    # Otherwise, we ask for the sudo
    print colorize(content.warning["sudo_password"], 'FAIL')
    return False


def find(pattern, path):
    """
    Will search for files we some patter in certain path. Use:
        find('*.txt', '/path/to/dir')

    :param pattern:String with the pattern to search for
    :param path:Where to search for (absolute or relative path)
    :return:Results of the search
    """
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if _fnmatch(name, pattern):
                result.append(os.path.join(root, name))
    return result


def file_exists(file_name):
    """
    Checks if a file named file_name exists
    :param file_name:Path to the file, with file included (e.g. "/etc/passwd.txt")
    :return:True if path is an existing regular file
    """
    return os.path.isfile(file_name)

def get_file_contents(file_name):
    """
    Gets the contents of a file
    :param file_name:Name of the file (and location)
    :return:Content of the file
    """
    with open(file_name, 'r') as f:
        content = f.read()
    f.closed

    return content

def get_json_online(url):
    """
    Get the parsed json from a url as a dictionary of lists
    :param url:Url to look for the json
    :return:The parsed json (dictionary of lists)
    """
    try:
        r = requests.get(url)
        if r.ok:
            return json.loads(r.text or r.content)

    except:
        print colorize(content.exceptions['unavailable'] % url, 'FAIL')

    raise EnvironmentError(content.exceptions['unexpected_online'])

def copytree(src, dst, symlinks = False, ignore = None):
    """
    Custom version of copy, which actually merges.
    See: http://stackoverflow.com/a/22331852/1104116
    :param src:
    :param dst:
    :param symlinks:
    :param ignore:
    :return:
    """
    if not os.path.exists(dst):
        os.makedirs(dst)
        shutil.copystat(src, dst)
    lst = os.listdir(src)
    if ignore:
        excl = ignore(src, lst)
        lst = [x for x in lst if x not in excl]
    for item in lst:
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if symlinks and os.path.islink(s):
            if os.path.lexists(d):
                os.remove(d)
            os.symlink(os.readlink(s), d)
            try:
                st = os.lstat(s)
                mode = stat.S_IMODE(st.st_mode)
                os.lchmod(d, mode)
            except:
                pass # lchmod not available
        elif os.path.isdir(s):
            copytree(s, d, symlinks, ignore)
        else:
            shutil.copy2(s, d)