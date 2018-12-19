#! /usr/bin/python
import sys
import os
import math
#from PIL import Image
#from PIL import ImageOps
#from PIL import ImageChops
import Image
import ImageOps
import ImageChops
from numpy import *

def convertTo8( image ):
  [min, max] = image.getextrema()
    #print min, max
  min = 0
  max = 4096
  table = [ (0 if (i<min) else (255 if (i>max) else ((float(i)-float(min))/float(max))*255.0)) for i in range(65536) ]
  return image.point(table, 'L')

def mip(images, out, t2b, weight):
  indices = xrange(len(images))
  if (not t2b):
    indices = reversed(indices)

  print "loading",len(images),"images..."

  firstTime = True
  for i in indices:
    #print "Examining image " + str(i) + "..."
    try:
      #loadedImg = convertTo8( Image.open( images[i] ).convert("I") )
      loadedImg = Image.open( images[i] ).convert("I")
      if firstTime:
        outImage = Image.new("L", loadedImg.size)
        outIdxIm = Image.new("L", loadedImg.size) #store index of outpixel source for later weighting.
        outdata = list(outImage.getdata())
        outidxs = list(outIdxIm.getdata())
        firstTime = False
      indata = loadedImg.getdata()
      for p in range(len(outdata)):
        if indata[p] > outdata[p]:
          outdata[p] = indata[p]
          if not t2b:
            outidxs[p] = len(images)-i;
          else:
            outidxs[p] = i+1
    except IOError, e:
      print e

  if weight:
    # Now weight outdata by indices of its source data.
    step = 1.0 / float(len(images))
    #print "step = " + str(step)
    for p in range(len(outdata)):
      #print "outdata[" + str(p) + "] = " + str(outdata[p]) + "("+str(outidxs[p])+")"
      outdata[p] *= (step*outidxs[p])

  outImage.putdata(outdata)
  outImage.save( out )


if __name__ == "__main__":
  images = []
  t2b = True
  weight = False

  # Fragile command line. Expects --t2b or --bt2, --save=/out/file --load space-seperated list.of in.files
  for arg in sys.argv[1:]:
    if arg.startswith("--save="):
      imageOut = arg.split("--save=")[1]
    elif arg == "--load":
      continue
    elif arg == "--t2b":
      t2b = True
      continue
    elif arg == "--b2t":
      t2b = False
      continue
    elif arg == "--weight":
      weight = True
      continue
    else:
      images.append(arg)

  for image in images:
    if imageOut == image:
      print "cannot overwrite input image", image
      sys.exit(1)

  if (t2b):
    print "top to bottom:"#,images
  else:
    print "bottom to top:"#,images

  mip( images, imageOut, t2b, weight )

