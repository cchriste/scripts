#! /bin/sh

# read and export the dimensions of an idx file

sed -n '/(box)/ {
n
p
}' < $1 | awk '{ split($0,n); print "export xres=" n[2]; print "export yres=" n[4]; print "export zres=" n[6]; }'
