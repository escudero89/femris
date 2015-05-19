# -*- coding: utf-8 -*-

import urllib2  # To download files
import os       # To remove files
import shutil   # To remove folders with files

# My project modules
from utils import *  # Utils module
import content  # My own files of strings


def retrieve_file(url, file_name=''):
    '''
    Retrieves a file from a certain url, showing a progress bar in console.
    :param url:
    :param file_name:
    :return:
    '''

    if len(file_name) == 0:
        file_name = url.split('/')[-1]

    u = urllib2.urlopen(url)
    f = open(file_name, 'wb')

    meta = u.info()
    file_size = int(meta.getheaders("Content-Length")[0])
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


def updater():
    # Lets show some initial info
    print colorize(content.es["separator"], 'HEADER')

    print colorize(content.es["intro"], 'HEADER')
    print "\n" + content.es["steps"],

    print colorize(content.es["separator"], 'BLUE')

    # Checks for the SO name and architecture
    os_name = get_os()
    architecture_sz = "64" if check_architecture_x64(os_name) else "32"

    print colorize(content.es["architecture"] % (os_name, architecture_sz),
                   'BLUE')

    # STEP 1 # We download the zipped file of the main binary
    print colorize(content.es["step_1"], 'BOLD')
    # retrieve_file(content.url["base" + architecture_sz], "Linux x86_64.zip")

    file_name_main = "test.zip"
    retrieve_file(content.url["test"], file_name_main)

    # STEP 2 # Then we download the zipped file of the resources
    print content.es["mild_separator"]
    print colorize(content.es["step_2"], 'BOLD')

    file_name_resources = "resources.zip"
    retrieve_file(content.url["resources"], file_name_resources)

    # STEP 3 # We uncompress the files into a temporal folder
    print content.es["mild_separator"]
    print colorize(content.es["step_3"], 'BOLD')
    uncompress_file(file_name_main)
    uncompress_file(file_name_resources)


    # STEP 5 # Removing files not longer in need
    print content.es["mild_separator"]
    print colorize(content.es["step_5"], 'BOLD')

    os.remove(file_name_main)
    os.remove(file_name_resources)

#    shutil.rmtree('temp')

def main():
    updater()


if __name__ == '__main__':
    main()
