#!/usr/bin/python
import sys
import os

visusconvert="visusconvert"  #add visusconvert to your path

if len(sys.argv) != 3:
    print "Usage: sub2wavelet.py input.idx output.idx";
    sys.exit();

input_file = str(sys.argv[1]);
output_file = str(sys.argv[2]);

output_folder = output_file[:output_file.find(".")];

input = open(input_file, "r");
source_idx = input.read();
input.close();


v=[i.strip() for i in source_idx.strip().split("\n")]
data_string = v[v.index('(fields)')+1];

species = data_string.split(" ");
name = species[0];
num = int(species[1].split("*")[0]);
stype = species[1].split("*")[1];

v[1] = "6";
v[v.index('(fields)')+1] = name + " " + str(num+1) + "*" + stype + " filter(max)";
template  = v[v.index('(filename_template)')+1];
v[v.index('(filename_template)')+1] = "./" + output_folder + "/" + template[template.find('%'):];

# output = open(output_file, "w");
# for i in v:
#     print output.write(i + "\n");
# output.close();

bbox_string = v[v.index('(box)')+1].split(" ");
dim_x = 248;#int(bbox_string[1]) - int(bbox_string[0]) + 1;
dim_y = 248;#int(bbox_string[3]) - int(bbox_string[2]) + 1;
dim_z = int(bbox_string[5]) - int(bbox_string[4]) + 1;

win_x = dim_x/4096;
win_y = dim_y/4096;

start_x = int(bbox_string[0])+2000;
start_y = int(bbox_string[2])+2000;
start_z = int(bbox_string[4])


infields=["C01","C02","C03","C04"]
outfields=["DAPI","BEN","VAS","OXY"]

CAST=" --cast 2*uint8"
#CAST=""

for f in xrange(len(infields)):
    for j in range(win_y):
        for i in range(win_x):
            box_string = str(start_x+(4096*i)) + " " + str(start_x+(4096*(i+1))-1) + " " + str(start_y+(4096*j)) + " " + str(start_y+(4096*(j+1))-1) + " " + str(start_z) + " " + bbox_string[5];
            s = visusconvert+" --import " + input_file + " --field " + infields[f] + " --box \"" + box_string + "\""+CAST+" --export " + output_file + " --use-write-lock --box \"" + box_string + "\" --field " + outfields[f];   
            print(s);
            os.system(s);
        box_string =  str(start_x+(4096*win_x)) + " " + bbox_string[1] + " " + str(start_y+(4096*j)) + " " + str(start_y+(4096*(j+1))-1) + " " + str(start_z) + " " + bbox_string[5];
        s = visusconvert+" --import " + input_file + " --field " + infields[f] + " --box \"" + box_string + "\""+CAST+" --export " + output_file + " --use-write-lock --box \"" + box_string + "\" --field " + outfields[f];   
        print(s);
        os.system(s);


    for i in range(win_x):
        box_string =  str(start_x+(4096*i)) + " " + str(start_x+(4096*(i+1))-1) + " " + str(start_y+(4096*win_y)) + " " + bbox_string[3] + " " + str(start_z) + " " + bbox_string[5];
        s = visusconvert+" --import " + input_file + " --field " + infields[f] + " --box \"" + box_string + "\""+CAST+" --export " + output_file + " --use-write-lock --box \"" + box_string + "\" --field " + outfields[f];   
        print(s);
        os.system(s);
#    box_string =  str(start_x+(4096*win_x)) + " " + bbox_string[1] + " " + str(start_y+(4096*win_y)) + " " + bbox_string[3] + " " + str(start_z) + " " + bbox_string[5];
    box_string =  str(start_x+(4096*win_x)) + " " + str(start_x+dim_x-1) + " " + str(start_y+(4096*win_y)) + " " +  str(start_y+dim_y-1) + " " + str(start_z) + " " + bbox_string[5];
    s = visusconvert+" --import " + input_file + " --field " + infields[f] + " --box \"" + box_string + "\""+CAST+" --export " + output_file + " --use-write-lock --box \"" + box_string + "\" --field " + outfields[f];   
    print(s);
    os.system(s);

