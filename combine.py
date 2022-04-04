import shutil, glob, re

outfilename = 'CMOAI.lua'

#copy contents of all lua files into master file
with open(outfilename, 'wb') as outfile:
    #copy all files that aren't main.lua
    for filename in glob.glob('./src/[!main]*'):
        if filename == outfilename:
            # don't want to copy the output into the output
            continue
        with open(filename, 'rb') as readfile:
            shutil.copyfileobj(readfile, outfile)
    #copy main.lua last
    shutil.copyfileobj(open('./src/main.lua','rb'),outfile)