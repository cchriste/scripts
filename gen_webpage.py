import sys, math, glob, os, Image

def makeheader(mypath, name="index"):
  #
  # make header
  #
  html_file = name + ".html"
  fileptr = open( html_file, "w" )
  print "Opening index.html"
  fileptr.write("<head>\n")
  fileptr.write("<title>Image Gallery for " + \
         mypath + "</title> \
  <meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\"/> \
  <style type='text/css'> \
  BODY {color: \#d0ffd0; background: \#333333; \
            font-family: Sans Serif, sans-serif; \
            font-size: 14pt; margin: 8%; } \
  H1       {color: \#d0ffd0;} \
  TABLE    {text-align: center; margin-left: auto; margin-right: auto;} \
  TD       { color: \#d0ffd0; padding: 1em} \
  IMG      { border: 1px solid \#d0ffd0; } \n")
  fileptr.write("</style>\n")
  fileptr.write("</head>\n")
  fileptr.write("<body>\n" )
  return fileptr


def gen_webpage(num_rows, size, src, name="index"):
  if not os.path.isdir(src):
    print "error:",src,"is not a valid location."
    exit()

  thumb_dir = "Thumbs"

  mkdir_cmd = "mkdir " + thumb_dir
  os.system( mkdir_cmd )
  #print  os.path.isfile( thumb_dir )
  #if os.path.isfile( thumb_dir ):
  #  print thumb_dir + "exits\n"
  #else:
  #  os.mkdir( thumb_dir )

  fileptr = makeheader(src, name)

  fileptr.write("<h1>Image Gallery for " + src + "</h1><p>")

  fileptr.write("<table>\n")

  fileptr.write("\n<tr>\n")

  i = 0
  allfiles = glob.glob(src + "/*.png")
  allfiles.sort()
  isize = int( size )
  #get all .png files in this directory
  for file in allfiles: #glob.glob( "*.png" ):
    print file

    # make a thumbnail
    img = Image.open( file )
    thumb_img = img.resize((isize,isize), Image.ANTIALIAS)
    thumb_filename = thumb_dir + "/" + os.path.basename(file)
    thumb_img.save( thumb_filename )

    if (i % num_rows == 0 ):
      fileptr.write("</tr>\n")
      fileptr.write("\n<tr>\n")  # start a new row
    # write image
    fileptr.write("<td align='center'>\n")
    fileptr.write("<a href=\"" + file + "\"><img src=\"" + thumb_filename + "\" + \
  width=\"" + size + "\" height=\"" + size + "\" /></a> \
  <div>" + os.path.basename(file) + "</div>\n" )
    fileptr.write("</td>\n")
    i = i + 1


  # make footer
  fileptr.write("</tr>\n")
  fileptr.write("</table>\n")
  fileptr.write("</body>\n")


  fileptr.close()



if __name__ == "__main__":
  if len(sys.argv) != 3:
    print "usage " + sys.argv[0] + " <num rows> <thumb size>"
    exit()

  num_rows = int( sys.argv[1] )
  size = sys.argv[2]
  gen_webpage(num_rows, size, '.')
