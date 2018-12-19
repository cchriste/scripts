import sys, os, glob, gen_webpage

def make_section(fileptr, name, path):
  fileptr.write("<li><a href=" + path + ">" + name + "</a></li>\n")

def gen_webpage_subs(fileptr, num_rows, size, src, name):
  print "genering webpage for", src, "and it's subdirectories..."
  fileptr.write("<ul>\n")
  make_section(fileptr, name, os.getcwd() + "/imgs.html")
  gen_webpage.gen_webpage(num_rows, size, src, "./imgs")

  files = os.listdir(src)
  for f in files:
    if os.path.isdir(src + "/" + f):
      try:
        os.mkdir(f)
      except OSError: # directory probably already exists
        pass
      os.chdir(f)
      gen_webpage_subs(fileptr, num_rows, size, "../" + src + "/" + f, f)
      os.chdir("..")

  fileptr.write("</ul>\n")


if __name__ == "__main__":
  if len(sys.argv) != 4:
    print "gen_webpage with subdirs"
    print "usage " + sys.argv[0] + " <src_dir> <num rows> <thumb size>"
    exit()

  src_dir = sys.argv[1]
  num_rows = int( sys.argv[2] )
  size = sys.argv[3]
  indexhtml = gen_webpage.makeheader(src_dir, "index")
  gen_webpage_subs(indexhtml, num_rows, size, src_dir, "TOP")



