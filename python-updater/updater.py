# -*- coding: utf-8 -*-

import urllib2  # To download files
import os       # To remove files
import shutil   # To remove folders with files
import sys      # To exit

# My project modules
from utils import *  # Utils module
import content  # My own files of strings
from github_handler import GithubHandler

def retrieve_file(url, file_name=''):
    """
    Retrieves a file from a certain url, showing a progress bar in console.
    :param url:
    :param file_name:
    :return:
    """
    if len(file_name) == 0:
        file_name_tmp = url.split('/')[-1]
        file_name = file_name_tmp.split('?')[0]

    try:
        u = urllib2.urlopen(url)
    except:
        raise EnvironmentError(content.exceptions['unavailable'] % url)

    f = open(file_name, 'wb')

    meta = u.info()
    file_size = int(meta.getheaders("Content-Length")[0])

    # Let's show some info
    print meta
    print content.es["downloading"] % (file_name, to_megabytes(file_size))

    file_size_dl = 0
    block_sz = 8192

    while True:
        streamed = u.read(block_sz)
        if not streamed:
            break

        file_size_dl += len(streamed)
        f.write(streamed)

        ratio_dl = file_size_dl * 100. / file_size

        status = "r%10d MB  [%3.2f%%]" % (to_megabytes(file_size_dl), ratio_dl)
        status += chr(8) * (len(status) + 1)

        print colorize(status, 'GREEN'),

    f.close()

    return file_name

def update_binary_linux(location):
    file_name = retrieve_file(location)

    # STEP 3 # We uncompress the files into a temporal folder
    print content.es["mild_separator"]
    print colorize(content.es["step_3"], 'BOLD')
    uncompress_file(file_name)

    # STEP 4 # We move the downloaded resources into its right directory
    print content.es["mild_separator"]
    print colorize(content.es["step_4"], 'BOLD')
    copytree('temp', '/opt/femris')

    # STEP 5 # Removing files not longer in need
    print content.es["mild_separator"]
    print colorize(content.es["step_5"], 'BOLD')
    os.remove(file_name)
    shutil.rmtree('temp')

def update_binary_windows(location):
    file_name = retrieve_file(location)

    # STEP 3 # We uncompress the files into a temporal folder
    print content.es["mild_separator"]
    print colorize(content.es["step_3"], 'BOLD')
    uncompress_file(file_name)

    # STEP 4 # We inform about the downloaded setup.exe
    print content.es["mild_separator"]
    print colorize(content.es["step_4_win"], 'GREEN')

    # STEP 5 # Removing files not longer in need
    print content.es["mild_separator"]
    print colorize(content.es["step_5"], 'BOLD')
    os.remove(file_name)

def update_resources(location):
    file_name = retrieve_file(location)

    # STEP 3 # We uncompress the files into a temporal folder
    print content.es["mild_separator"]
    print colorize(content.es["step_3"], 'BOLD')
    uncompress_file(file_name)

    # STEP 4 # We move the downloaded resources into its local directory
    print content.es["mild_separator"]
    print colorize(content.es["step_4"], 'BOLD')
    copytree('temp', '../')

    # STEP 5 # Removing files not longer in need
    print content.es["mild_separator"]
    print colorize(content.es["step_5"], 'BOLD')
    os.remove(file_name)
    shutil.rmtree('temp')

def updater(os_name, architecture_sz):

    # STEP 0 # We check whether we need to update or not, based on GitHub
    github_handler = GithubHandler(os_name, architecture_sz)
    if not github_handler.get_update_status():
        return False

    # STEP 1 # We download the zipped file of the main binary (if we need)
    if github_handler.update_binary['url']:
        print colorize(content.es["step_1"], 'BOLD')

        if (os_name == "Windows"):
            update_binary_windows(github_handler.update_binary['url'])
        else:
            update_binary_linux(github_handler.update_binary['url'])

        return github_handler

    else:
        print colorize(content.es["step_1_jmp"], 'BOLD')

    # STEP 2 # Then we download the zipped file of the resources (if we need)
    if github_handler.update_resources['url']:
        print colorize(content.es["step_2"], 'BOLD')
        update_resources(github_handler.update_resources['url'])
        #update_resources(content.url["test"])
        return github_handler
    else:
        print colorize(content.es["step_2_jmp"], 'BOLD')

    return False

def init():

    # Before anything, lets check for the SO name and architecture
    os_name = get_os()
    architecture_sz = "64" if check_architecture_x64(os_name) else "32"
    current_os = os_name

    print colorize(content.es["architecture"] % (os_name, architecture_sz),
                   'BLUE')

    # We ask for higher permission (if required)
    if os_name == "Linux" and ask_for_sudo() == False:
        sys.exit(content.error_codes['ask_for_sudo'])

    # Lets show some initial info
    print colorize(content.es["separator"], 'HEADER')

    print colorize(content.es["intro"], 'HEADER')
    print "\n" + content.es["steps"],

    print colorize(content.es["separator"], 'BLUE')

    # We make the update
    github_handler = updater(os_name, architecture_sz)
    if github_handler:
        # We need to also update our own current.json for future updates
        github_handler.update_current()

if __name__ == '__main__':

    init()

    # Final separator
    print colorize(content.es["separator"], 'HEADER')

    k = raw_input(content.es["salir"])