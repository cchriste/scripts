#!/bin/python

#***************************************************
#** ViSUS Visualization Project                    **
#** Copyright (c) 2010 University of Utah          **
#** Scientific Computing and Imaging Institute     **
#** 72 S Central Campus Drive, Room 3750           **
#** Salt Lake City, UT 84112                       **
#**                                                **
#** For information about this project see:        **
#** http:#www.pascucci.org/visus/                 **
#**                                                **
#**      or contact: pascucci@sci.utah.edu         **
#**                                                **
#****************************************************

from visuspy import *
import sys
sys.path.append('/Users/cam/tools/pyhdf/lib/python2.7/site-packages')
from pyhdf import SD

###############################################################################
def createFileList(basename):
  # Create an ordered list of files from template_filename which may contain unix shell-style expansions (*, ?, []).
  import glob
  filelist=glob.glob(basename)
  filelist.sort()
  return filelist

###############################################################################
class HdfUtil:

  # createIdx
  def createIdx(self,filelist,idxname,idxdata):
    # Create IDX volume from the hdf files in filelist.
    # Automatically determines resolution of volume.

    if len(filelist)==0:
      return

    nslices_per_write=256 # faster to write a group of slices all at once if you have sufficient memory
    
    # Open the first file to determine dimensions of the volume.
    zdim=len(filelist)
    fd=SD.SD(filelist[0]).select(0)
    xdim,ydim=fd.dimensions().values()
    hdbuf=fd.get()
    DTYPE=DType.New(hdbuf.dtype.name)
    NDTYPE=1
    #buf=numpy.array(numpy.zeros((xdim*ydim*nslices_per_write,),dtype=hdbuf.dtype))
    buf=numpy.array(numpy.zeros((0,),dtype=hdbuf.dtype))
    print "dimensions: %d x %d x %d" % (xdim,ydim,zdim)

    # Create the IDX volume
    userbox=NdBox()
    userbox.From=NdPoint(0,0,0)
    userbox.To  =NdPoint(xdim-1,ydim-1,zdim-1)
    flags="compressed"
    fields="data %d*%s %s" % (NDTYPE,DType.toString(DTYPE),flags)
    bitsperblock=0        # Automatically determine bitmask and bitsperblock
    bitmask_pattern=""
    vf=IdxDataset.New(idxname,idxdata,userbox,fields,bitmask_pattern,bitsperblock)
    assert(vf)
    field=vf.getField()
    time=vf.getTimeFrom()
    access=vf.createAccess()

    # Write all the files nslices at a time.
    slicenum=0
    startslice=0
    for I in range(0,len(filelist)):
      slicenum=slicenum+1

      # Open the file
      print "reading",filelist[I],"..."
      fd=SD.SD(filelist[I]).select(0)
      
      # Verify dimensions
      fxdim,fydim=fd.dimensions().values()
      assert(fxdim==xdim and fydim==ydim)

      # Copy the data to Visus MemoryBlock
      hdbuf=numpy.ravel(fd.get())
      #numpy.copyto(buf[xdim*ydim*(slicenum-1)],hdbuf)   #not sure how to reference internal array location for dst (1st argument)
      buf=numpy.append(buf,hdbuf)                        #so instad just use append
#this was slow way to do the same
#      for i in range(0,ydim):
#        for j in range(0,xdim):
#          buf[(slicenum-1)*ydim*xdim+i*xdim+j]=hdbuf[i][j]

      if slicenum==nslices_per_write:
        # Create the IDX query
        userbox.From.z=startslice
        userbox.To.z=startslice+slicenum-1
        print "writing slices",userbox.From.z,"through",userbox.To.z
        write=vf.createIdxBoxQuery(userbox,field,time,0,vf.maxh,vf.maxh)
        assert(write)
        write.setBuffer(MemoryBlock(buf))
        retval=write.execute(access,ord('w'))
        assert(retval==QueryFinished)
        startslice=startslice+slicenum
        slicenum=0

    #write remainder
    if slicenum>0:
      # Create the IDX query
      userbox.From.z=startslice
      userbox.To.z=startslice+slicenum-1
      print "writing slices",userbox.From.z,"through",userbox.To.z,"(remainder)"
      write=vf.createIdxBoxQuery(userbox,field,time,0,vf.maxh,vf.maxh)
      assert(write)
      write.setBuffer(MemoryBlock(buf))
      retval=write.execute(access,ord('w'))
      assert(retval==QueryFinished)

    print "done!"

    
    
# ############################
if __name__ == '__main__':
  app=Application();app.setCommandLine("_visuspy.pyd")
  ENABLE_VISUS_IDX()  

  if len(sys.argv)<4:
    print "hdf2idx.py: creates ViSUS IDX volume from specified hdf4 files, interpreted as one slice per file."
    print "usage:   python hdf2idx.py \"<wildcard_filename>\" <idx_filename> <idx_data_dirname>"
    print "example: python hdf2idx.py \"/scratch/foo_data*.hdf\" /data/myidx.idx myidx"
    print "note: the wildcard_filename must be in quotes."
  basename=sys.argv[1]
  idxfile=sys.argv[2]
  idxdata=sys.argv[3]

  filelist=createFileList(basename)

  HdfUtil().createIdx(filelist,idxfile,idxdata)
