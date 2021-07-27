#!/bin/bash

#mkdir year_regex_output_body_mag
#mkdir year_regex_output_body_mag/old
#mv year_regex_output_body_mag/*.txt year_regex_output_body_mag/old

#for year in {1788..1788}
#for year in {1800..2020}
#for year in {1799..2020}
for year in {2007..2007}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_scripts_body_mag/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  srun -J xj_mg_bd -p large -o $NPL_BASE/nplmatch/splitjournal_articles/year_regex_output_body_mag/year$year-$jobnum.txt perl $NPL_BASE/nplmatch/splitjournal_articles/year_regex_scripts_body_mag/year$year-$jobnum.pl &
  #srun -p large -o $NPL_BASE/nplmatch/splitjournal_articles/year_regex_output_body_mag/fdsa5 perl $NPL_BASE/nplmatch/splitjournal_articles/year_regex_scripts_body_mag/year1788-1000.pl &
  #srun -p large -o $NPL_BASE/nplmatch/splitjournal_articles/year_regex_output_body_mag/year$year-$jobnum.txt perl $NPL_BASE/nplmatch/splitjournal_articles/year_regex_scripts_body_mag/year$year-$jobnum.pl &
 done
done

