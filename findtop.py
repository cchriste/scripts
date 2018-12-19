#! /usr/bin/python


# test
# import os
# from PIL import Image
# home = os.getenv("HOME")
# im = Image.open(home + "/Desktop/newdawn_avatar.jpg")
# im.rotate(45).show()

import sys
import os
import math
from PIL import Image
from PIL import ImageOps
from PIL import ImageChops
from numpy import *

threshold = 50

def findTopOrBottom(images, out, top):
    items = range(len(images))
    if (not top):
        items = reversed(items)
    firstTime = True
    step = 255 / len(images)
    print "step = " + str(step)
    for i in items:
        print "Examining image " + str(i) + "..."
        try:
            loadedImg = Image.open( images[i] )
            if firstTime:
                outImage = Image.new("L", loadedImg.size)
                outdata = list(outImage.getdata())
                firstTime = False
            indata = loadedImg.getdata()
            for p in range(len(outdata)):
#                print "indata[" + str(i) + "] = " + str(indata[i])
                if outdata[p] == 0 and indata[p] > threshold:
                        outdata[p] = step * (i+1)
        except IOError, e:
            print e

    outImage.putdata(outdata)
    outImage.save( out )


if __name__ == "__main__":
    images = []
    top = True

    # Fragile command line. Expects --top or --bot, --save=/out/file --load space-seperated list.of in.files
    for arg in sys.argv[1:]:
        if arg.startswith("--save="):
            imageOut = arg.split("--save=")[1]
        elif arg == "--load":
            continue
        elif arg == "--top":
            top = True
            continue
        elif arg == "--bot":
            top = False
            continue
        else:
            images.append(arg)

    for image in images:
        if imageOut == image:
            print "cannot overwrite input image", image
            sys.exit(1)

    if (top):
        print "Finding top..."
    else:
        print "Finding bottom..."
    findTopOrBottom( images, imageOut, top )

