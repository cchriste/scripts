#! /usr/bin/python

# gather a group of mosaicked pngs as produced by Iris into a common directory with a unique naming convention.

import sys
import os
import shutil
import re

def copyimgs(dir, dest, filter):
    dir = os.path.abspath(dir)
    #print "scanning", dir
    for f in os.listdir(dir):
        if os.path.isdir(os.path.join(dir, f)):
            copyimgs(os.path.join(dir, f), dest, filter)
        if f.endswith(".png"):
            channel = dir.split('/')[-2]
            slice = dir.split('/')[-3]
            print slice, channel, os.getcwd()
#            return
#            dest += "/" + channel + "/" + downsample
#            if not os.path.exists(dest):
#                os.makedirs(dest)
            src = os.path.join(dir, f)
            dst = os.path.join(dest, slice + '_' + channel + '_mosaic.png')
            print "copying",os.path.basename(src),"to",dst
            shutil.copy(src, dst)


if __name__ == "__main__":
    dest = os.getcwd()
    print "copying all images to", dest
    filter = ""
    if len(sys.argv) == 3:
        filter = sys.argv[2]
    copyimgs(sys.argv[1], dest, filter)


    
