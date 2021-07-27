#!/bin/bash

mkdir year_regex_output_body_wos
mkdir year_regex_output_body_wos/old
mv year_regex_output_body_wos/*.txt year_regex_output_body_wos/old

#for year in {2018..2019}
for year in {1900..2019}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_scripts_body_wos/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -N xj_ws_bd -hold_jid bj_ws_bd -l h_rt=96:00:00 -o year_regex_output_body_wos/year$year-$jobnum.txt -b y year_regex_scripts_body_wos/year$year-$jobnum.pl
 done
done

