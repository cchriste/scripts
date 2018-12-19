#! /usr/bin/python

import os
import re
import glob

tmp = "./tmp.png"
files = glob.glob("0003*.png")
cnt = 1
files.reverse()
for f in files:
    os.rename(f, "0003-00" + "%02d" % cnt + "_mosaic.png.tmp")
    cnt += 1

for f in files:
    os.rename(f + ".tmp", f)
    
