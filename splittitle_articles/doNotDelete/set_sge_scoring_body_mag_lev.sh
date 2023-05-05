#!/bin/bash
rm -f year_regex_scored_body_mag_lev/*.txt
for year in {1800..2019}
#for year in {1800..1800}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_output_body_mag_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -V -P marxnsf1 -N st_mg_bd -hold_jid xt_mg_bd -o year_regex_scored_body_mag_lev/scored$year-$jobnum.txt ../process_matches/score_matches.pl year_regex_output_body_mag_lev/year$year-$jobnum.txt -body
 done
done

