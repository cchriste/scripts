
# rename.py
#
# Rename a group of files.
#

import re
import os
import glob

for i in os.listdir('.'):
#    newname = re.sub("\d(\d\d)(.*)\.jpg", "\g<2>0-\g<1>-0.jpg", i)
    newname = re.sub("\d(\d\d)(.*)\.jpg", "image0-\g<1>-0.jpg", i)
    print "Renaming ", i, "to", newname, "..."
    os.rename(i, newname)


# This one swaps the rows and columns of files of the name fileX-c-r.ext.
for f in os.listdir('.'):
	idx1 = f.index('-')
	idx2 = f.index('-', idx1 + 1)
	c = f[f.index('-') + 1 : idx2]
	r = f[idx2+1 : f.index('.')]
	name = f[0:idx1] + '-' + r + '-' + c + f[f.index('.'):]
	os.rename(f, name)

# This one does the same thing, but globs only the .png files (the
# second part is because there are duplicate names, so the temp names
# are prefixed with and underscore and then it is removed.
for f in glob.glob('*.png'):
    idx1 = f.index('-')
    idx2 = f.index('-', idx1 + 1)
    c = f[f.index('-') + 1 : idx2]
    r = f[idx2+1 : f.index('.')]
    name = '_' + f[0:idx1] + '-' + r + '-' + c + f[f.index('.'):]
    os.rename(f, name)

for f in glob.glob('*.png'):
    os.rename(f, f[1:])


# This one pads the rows and cols of selected files.
>>> for i in os.listdir('.'):
	m = re.match("(.*0-)0*(\d+)-0\.jpg", i)
	num = int(m.group(2)) - 1
	newname = m.expand("\g<1>")
	newname += str(num) + "-0.jpg"
	print "Moving", i, "to", newname
	os.rename(i, newname)

	
Moving image0-01-0.jpg to image0-0-0.jpg
Moving image0-02-0.jpg to image0-1-0.jpg
Moving image0-03-0.jpg to image0-2-0.jpg
Moving image0-04-0.jpg to image0-3-0.jpg
Moving image0-05-0.jpg to image0-4-0.jpg
Moving image0-06-0.jpg to image0-5-0.jpg
Moving image0-07-0.jpg to image0-6-0.jpg
Moving image0-08-0.jpg to image0-7-0.jpg
Moving image0-09-0.jpg to image0-8-0.jpg
Moving image0-10-0.jpg to image0-9-0.jpg
Moving image0-11-0.jpg to image0-10-0.jpg
Moving image0-12-0.jpg to image0-11-0.jpg
Moving image0-13-0.jpg to image0-12-0.jpg
Moving image0-14-0.jpg to image0-13-0.jpg
Moving image0-15-0.jpg to image0-14-0.jpg
Moving image0-16-0.jpg to image0-15-0.jpg
Moving image0-17-0.jpg to image0-16-0.jpg
Moving image0-18-0.jpg to image0-17-0.jpg
Moving image0-19-0.jpg to image0-18-0.jpg
Moving image0-20-0.jpg to image0-19-0.jpg
Moving image0-21-0.jpg to image0-20-0.jpg
Moving image0-22-0.jpg to image0-21-0.jpg
Moving image0-23-0.jpg to image0-22-0.jpg
Moving image0-24-0.jpg to image0-23-0.jpg
Moving image0-25-0.jpg to image0-24-0.jpg
Moving image0-26-0.jpg to image0-25-0.jpg
Moving image0-27-0.jpg to image0-26-0.jpg
Moving image0-28-0.jpg to image0-27-0.jpg
Moving image0-29-0.jpg to image0-28-0.jpg
Moving image0-30-0.jpg to image0-29-0.jpg
Moving image0-31-0.jpg to image0-30-0.jpg
Moving image0-32-0.jpg to image0-31-0.jpg
Moving image0-33-0.jpg to image0-32-0.jpg
Moving image0-34-0.jpg to image0-33-0.jpg
Moving image0-35-0.jpg to image0-34-0.jpg
Moving image0-36-0.jpg to image0-35-0.jpg
Moving image0-37-0.jpg to image0-36-0.jpg
Moving image0-38-0.jpg to image0-37-0.jpg
Moving image0-39-0.jpg to image0-38-0.jpg
Moving image0-40-0.jpg to image0-39-0.jpg
Moving image0-41-0.jpg to image0-40-0.jpg
Moving image0-42-0.jpg to image0-41-0.jpg
Moving image0-43-0.jpg to image0-42-0.jpg
Moving image0-44-0.jpg to image0-43-0.jpg
Moving image0-45-0.jpg to image0-44-0.jpg
Moving image0-46-0.jpg to image0-45-0.jpg
Moving image0-47-0.jpg to image0-46-0.jpg
Moving image0-48-0.jpg to image0-47-0.jpg
Moving image0-49-0.jpg to image0-48-0.jpg
>>> 

