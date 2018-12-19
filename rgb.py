#! /usr/bin/python
#
# print alternate values of rgb triplet
#

import sys
from math import sqrt

if __name__ == "__main__":
    if len(sys.argv)!=2 and len(sys.argv)!=4:
        print "Example usage0: rgb 241 239 221"
        print "Example usage1: rgb 0.2 1.0 0.887"
        print "Example usage2: rgb \"#ffda34\""
        exit()

    do_float=False
    if sys.argv[1][0]=='#':
        r=int(sys.argv[1][1:3],16)
        g=int(sys.argv[1][3:5],16)
        b=int(sys.argv[1][5:7],16)
    else:
        r=float(sys.argv[1])
        g=float(sys.argv[2])
        b=float(sys.argv[3])
        if sys.argv[1].find(".") != -1:
            do_float=True;
            
    fr=r;
    fg=g;
    fb=b;
    if not do_float:
        fr=r/255.0
        fg=g/255.0
        fb=b/255.0
    else:
        r*=255
        g*=255
        b*=255

    #print r,g,b
    #print fr,fg,fb
    norm=(fr+fg+fb)/3

    print "<%d %d %d> = <%x %x %x> = <%.3f %.3f %.3f>, norm=%.3f, normalized = <%.3f %.3f %.3f>"%(r,g,b,r,g,b,fr,fg,fb,norm,fr/norm,fg/norm,fb/norm)


    
