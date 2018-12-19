#! /usr/bin/python

# gather a group of mosaicked pngs as produced by Iris into a common directory with a unique naming convention.

import sys
import os
import shutil

def copyimgs(dir, dest):
    dir = os.path.abspath(dir)
    #print "scanning", dir
    for f in os.listdir(dir):
        if os.path.isdir(os.path.join(dir, f)):
            copyimgs(os.path.join(dir, f), dest)
        if f == "assembled_mosaic.png":
            more, downsample = os.path.split(dir)
            more, channel = os.path.split(more)
            slice = os.path.basename(more)
            print slice, channel, downsample, os.getcwd()
            dest += "/" + channel + "/" + downsample
            if not os.path.exists(dest):
                os.makedirs(dest)
            src = os.path.join(dir, f)
            dst = os.path.join(dest, slice + '_mosaic.png')
            print "copying",os.path.basename(src),"to",dst
            shutil.copy(src, dst)
            break


if __name__ == "__main__":
    dest = os.getcwd()
    print "copying all images to", dest
    copyimgs(sys.argv[1], dest)


    
