#!/usr/bin/env python

# author: Dave dV (http://unknowngenius.com/blog/)

# Small script to decode zip archives made on different systems while preserving
# filenames in non-English languages (particularly Japanese)

# reusing code from: http://stackoverflow.com/questions/1807063/extract-files-with-invalid-characters-in-filename-with-python

# More info here: http://unknowngenius.com/blog/archives/2011/11/04/recovering-japanese-filenames-from-zip-archives-on-os-x

# Use at your own risk, feel free to improve and redistribute!

import shutil
import zipfile
from sys import argv

def remove(value, deletechars):
    for c in deletechars:
        value = value.replace(c, '-')
    return value;

if len(argv) < 2:
    print "\n*** Need a file to unzip ***\n\nUsage: %s filename.zip [optional encoding]\n(if no source encoding is provided, Windows 'sjis' will be assumed by default)" % argv[0]
    quit()

if len(argv) > 2:
    encoding = argv[2]
else:
    encoding = 'sjis'
    
print "Unpacking archive: '%s' using encoding %s" % (argv[1], encoding)
f = zipfile.ZipFile(argv[1], 'r')
for fileinfo in f.infolist():
    filename = remove(unicode(fileinfo.filename, encoding), ':\/')
    print filename
#    outputfile = open(filename, "wb")
#    shutil.copyfileobj(f.open(fileinfo.filename), outputfile)
