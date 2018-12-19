# Python3 script to rename exported OSX Photos directories.
# note: must install 'arrow' using 'pip3 install arrow'.

import os, arrow

def main():
    for dirname in os.listdir("."):
        try:
            aDate=arrow.get(dirname,'MMMM D, YYYY')
        except arrow.parser.ParserError:
            print("Ignoring",dirname,"since it contains no MMMM D, YYYY date string.")
        else:
            newDirname=aDate.format('YYYY.MM.DD-')+dirname
            print("renaming",dirname,"to",newDirname)
            os.rename(dirname,newDirname)

# Driver Code
if __name__ == '__main__':
    main()
