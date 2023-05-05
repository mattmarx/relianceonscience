#!/bin/bash

mkdir year_regex_output_front_mag_lev
mkdir year_regex_output_front_mag_lev/old
mv year_regex_output_front_mag_lev/*.txt year_regex_output_front_mag_lev/old

for year in {1799..1979}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_scripts_front_mag_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -N xt_mg_ft -hold_jid bt_mg_ft -o year_regex_output_front_mag_lev/year$year-$jobnum.txt -b y year_regex_scripts_front_mag_lev/year$year-$jobnum.pl
 done
done

