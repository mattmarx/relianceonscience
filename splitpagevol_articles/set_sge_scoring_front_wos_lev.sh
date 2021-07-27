#!/bin/bash
mkdir year_regex_scored_front_wos_lev
rm -f year_regex_scored_front_wos_lev/*.txt
for year in {1900..2019}
#for year in {1979..1979}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_output_front_wos_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -V -P marxnsf1 -N sc_ws_ft -hold_jid xc_ws_ft -o year_regex_scored_front_wos_lev/scored$year-$jobnum.txt ../process_matches/score_matches.pl year_regex_output_front_wos_lev/year$year-$jobnum.txt
 done
done

for year in {1799..1799}
#for year in {1979..1979}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_output_front_wos_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -V -P marxnsf1 -N sc_ws_ft -hold_jid xc_ws_ft -o year_regex_scored_front_wos_lev/scored$year-$jobnum.txt ../process_matches/score_matches.pl year_regex_output_front_wos_lev/year$year-$jobnum.txt
 done
done

