#!/bin/bash

#mkdir year_regex_output_front_mag_lev
#mkdir year_regex_output_front_mag_lev/old
#mv year_regex_output_front_mag_lev/*.txt year_regex_output_front_mag_lev/old

#for year in {1788..1788}
#for year in {1800..1801}
for year in {1799..1799}
#for year in {1799..2020}
#for year in {1803..1803}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_scripts_front_mag_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  srun -J xpfm$year$jobnum -t 96:00:00 -p large -o $NPL_BASE/nplmatch/splitpagevol_articles/year_regex_output_front_mag_lev/year$year-$jobnum.txt perl $NPL_BASE/nplmatch/splitpagevol_articles/year_regex_scripts_front_mag_lev/year$year-$jobnum.pl &
  #srun -p large -o $NPL_BASE/nplmatch/splitpagevol_articles/year_regex_output_front_mag_lev/fdsa5 perl $NPL_BASE/nplmatch/splitpagevol_articles/year_regex_scripts_front_mag_lev/year1788-1000.pl &
  #srun -p large -o $NPL_BASE/nplmatch/splitpagevol_articles/year_regex_output_front_mag_lev/year$year-$jobnum.txt perl $NPL_BASE/nplmatch/splitpagevol_articles/year_regex_scripts_front_mag_lev/year$year-$jobnum.pl &
 done
done

