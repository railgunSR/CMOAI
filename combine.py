from typing import List
import shutil, glob, sys, re, os

appendDebug = False

if len(sys.argv)>1:
    if(re.match("debug",sys.argv[1])):
        appendDebug = True

outfilename = 'CMOAI.lua'

#copy contents of all lua files into master file
with open(outfilename, 'wb') as outfile:
    files : List = glob.glob(os.path.join(".","src","*"))
    #remove main.lua so we can place it at the bottom of the file
    files.remove(os.path.join(".","src","main.lua"))
    #check if we need to add debug declares
    if(appendDebug):
        with open(os.path.join(".","test","enginedeclares.lua"), 'rb') as readfile:
            shutil.copyfileobj(readfile,outfile)
    # print(files)
    #copy all files that aren't main.lua
    for filename in files:
        if filename == outfilename:
            # don't want to copy the output into the output
            continue
        with open(filename, 'rb') as readfile:
            shutil.copyfileobj(readfile, outfile)
    #copy main.lua last
    shutil.copyfileobj(open(os.path.join(".","src","main.lua"),'rb'),outfile)