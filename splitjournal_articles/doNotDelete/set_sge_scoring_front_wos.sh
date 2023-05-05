#!/bin/bash
rm -f year_regex_scored_front_wos/*.txt
for year in {1900..2019}
#for year in {1979..1979}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_output_front_wos/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -V -P marxnsf1 -N sj_ws_ft -hold_jid xj_ws_ft -o year_regex_scored_front_wos/scored$year-$jobnum.txt ../process_matches/score_matches.pl year_regex_output_front_wos/year$year-$jobnum.txt
 done
done

