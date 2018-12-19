#! /bin/bash

# add these two lines to .bashrc
# export OMDB_API_KEY=12dc5051
# alias omdbtool="python $HOME/tools/omdb-cli/omdbtool.py"

ls -1 |
while read title; do
  res=`python $HOME/tools/omdb-cli/omdbtool.py -t "$title"`
  rating=`echo "$res" | sed -n '/^imdbrating/{n;p;}'`
  restitle=`echo "$res" | sed -n '/^title/{n;p;}' | sed s/*//g`
  year=`echo "$res" | sed -n '/^year/{n;p;}'`
  echo "$title  *  $restitle  *  $year  *  $rating"
done
