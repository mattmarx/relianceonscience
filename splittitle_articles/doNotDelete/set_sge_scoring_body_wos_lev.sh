#!/bin/bash
rm -f year_regex_scored_body_wos_lev/*.txt
for year in {1900..2019}
#for year in {1979..1979}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_output_body_wos_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -V -P marxnsf1 -N st_ws_bd -hold_jid xt_ws_bd -o year_regex_scored_body_wos_lev/scored$year-$jobnum.txt -b y ../process_matches/score_matches.pl year_regex_output_body_wos_lev/year$year-$jobnum.txt -body
 done
done


