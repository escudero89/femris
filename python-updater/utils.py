# To check for sudo
import sys
import os
from subprocess import check_call as _check_call

# To check for the system architecture and name
import platform
import struct

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
        exit(101)

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
    exit(102)

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
    print colorize(content.warning["sudo_password"], 'WARNING')
    return False

