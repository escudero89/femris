# -*- coding: utf-8 -*-

import urllib2  # To download files
import struct   # To check for the system architecture

# My project modules
from utils import *  # Utils module
import content  # My own files of strings

def retrieve_file(url, file_name = ''):
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

        status = r"%10d MB  [%3.2f%%]" % (to_megabytes(file_size_dl), ratio_dl)
        status = status + chr(8)*(len(status)+1)

        print colorize(status, 'GREEN'),

    f.close()

def updater():

    # Lets show some initial info
    print colorize(content.es["separator"], 'HEADER')

    print colorize(content.es["intro"], 'HEADER')
    print "\n" + content.es["steps"]


    # Checks the architecture of the SO
    is_x64 = False
    if struct.calcsize("P") * 8 == 64:
        is_x64 = True

    architecture_sz = "64" if is_x64 else "32"

    print colorize(content.es["architecture"] % architecture_sz, 'BLUE')

    # Now we call the file
    print colorize(content.es["step_1"], 'BOLD')
    retrieve_file(content.url["base" + architecture_sz], "Linux x86_64.zip")


def main():
    updater()


if __name__ == '__main__':
    main()
