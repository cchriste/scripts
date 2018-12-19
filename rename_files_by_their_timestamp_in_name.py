# Python3 script to rename files with timestamp in their names.
# (was specifically for some old voice memos)
# note: must install 'arrow' using 'pip3 install arrow'.

import os, arrow

def main():
    for name in os.listdir("."):
        try:
            aDate=arrow.get(name,'M_D_YY h_mm A')
        except arrow.parser.ParserError:
            print("Ignoring",name,"since it contains no M_D_YY h_mm A date string.")
        else:
            newName=aDate.format('YYYYMMDD HHmmss-')+name
            print("renaming",name,"to",newName)
            os.rename(name,newName)

# Driver Code
if __name__ == '__main__':
    main()
