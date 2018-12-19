# cvs-add-tree.py
#
# This script (my very first python) adds a given directory and all its subs
# to the specified cvs repository.
#

import os
import sys
from optparse import OptionParser

parser = OptionParser(usage="usage: %prog [options] dir")
parser.add_option("-n", "--nothing", action="store_true", dest="innocuous", 
                  default=False, 
                  help="this execution will not perform any permanent action")
parser.add_option("-d", "--dir", dest="cvsroot", default=os.environ['CVSROOT'],
                  help="the cvs repository to which the directory will be added")
(options, args) = parser.parse_args()
#print "option pairs: ", options
#print "remaining arguments: ", args

cvsroot = options.cvsroot
innocuous = options.innocuous

if innocuous:
    print "(Innocuous mode: no actual actions will be performed.)"

if (len(args) != 1):
    print "Invalid directory specified"
    parser.print_help()
    sys.exit(20)

directory=args[0]   # the directory to be copied

# verify that directory is actually a directory
if os.access(directory, F_OK) == False:
    print directory, "does not exist."
    sys.exit(21)

print "adding", directory, "and all its subs to", cvsroot, "\nContinue? "

# add directory, recurse into directory and add all subs
#(it turns out there is a cvs command to 'import' a new tree all at once, 
# which is what I was trying to do.  I'll just use cvs import.)
