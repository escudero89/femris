from distutils.core import setup
import py2exe, sys, os

sys.argv.append('py2exe')

setup(
    options = {
        'py2exe': {
            'bundle_files': 3,
            'compressed': 2,
            'optimize': 2
        }
    },
    console = ['updater.py'],
    zipfile = None,
)
