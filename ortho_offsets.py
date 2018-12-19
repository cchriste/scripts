from __future__ import division

NX=8
NY=8
sx=1.0/NX
sy=1.0/NY
for x in range(NX):
    for y in range(NY):
        xoff=x*sx
        yoff=y*sy
        print "\""+str(xoff)+" "+str(yoff)+" "+str(sx)+" "+str(sy)+"\""
