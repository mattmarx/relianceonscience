#!/bin/bash

mkdir year_regex_output_front_wos
mkdir year_regex_output_front_wos/old
mv year_regex_output_front_wos/*.txt year_regex_output_front_wos/old

for year in {1900..2019}
#for year in {1956..1956}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_scripts_front_wos/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -N xj_ws_ft -hold_jid bj_ws_ft -l h_rt=96:00:00 -o year_regex_output_front_wos/year$year-$jobnum.txt -b y year_regex_scripts_front_wos/year$year-$jobnum.pl
 done
done

