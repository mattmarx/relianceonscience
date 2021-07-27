#!/bin/bash

#mkdir year_regex_output_front_mag_lev
#mkdir year_regex_output_front_mag_lev/old
#mv year_regex_output_front_mag_lev/*.txt year_regex_output_front_mag_lev/old

#for year in {1788..1788}
#for year in {1800..1801}
for year in {1799..1799}
#for year in {1799..2020}
#for year in {1944..1944}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_output_front_mag_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  srun -J stfm$year$jobnum -p large -o $NPL_BASE/nplmatch/splittitle_articles/year_regex_scored_front_mag_lev/year$year-$jobnum.txt perl $NPL_BASE/nplmatch/process_matches/score_matches.pl $NPL_BASE/nplmatch/splittitle_articles/year_regex_output_front_mag_lev/year$year-$jobnum.txt &
 done
done

