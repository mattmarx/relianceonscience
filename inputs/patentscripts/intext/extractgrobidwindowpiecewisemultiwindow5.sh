#!/bin/bash

### Author: Joshua Chu
### Date: February 6, 2023

### command structure: sh extractgrobidwindowpiecewise.sh

grobidpath="$NPL_BASE/nplmatch/grobid/window"

input=$(eval echo $grobidpath/grobidbatch/directory_grobid)
output=$(eval echo $grobidpath/grobidbatch/directory_grobid/directory_grobid_out)

for ((i=12490; i<=12499; i++))
do

 echo "doing windowscombined-$i"
 python3 $patentscripts/intext/multi_proc_prog.py $input/windowscombined-$i $output/grobidwindowoutput-$i
 chmod 777 $output/grobidwindowoutput-$i

done

