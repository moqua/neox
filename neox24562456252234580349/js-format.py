#!/usr/bin/python

import os
import sys

#import pftool

if __name__ == '__main__':
    command = 'java org.mozilla.javascript.tools.shell.Main -classpath /usr/share/java/js.jar beautify-cl.js'
    command += ' -i 4 ' + ' '.join(sys.argv[1:])
#    os.chdir(pftool.tools_dir)
    os.chdir("einars-js-beautify-f614cc4")
    code = os.system(command)
    sys.exit(code)
