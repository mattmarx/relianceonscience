#!/bin/bash
rm -f year_regex_scored_front_mag_lev/*.txt
for year in {1799..2019}
#for year in {1799..1799}
#for year in {1979..1979}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_output_front_mag_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -V -P marxnsf1 -N sc_mg_ft -hold_jid xc_mg_ft -o year_regex_scored_front_mag_lev/scored$year-$jobnum.txt -b y ../process_matches/score_matches.pl year_regex_output_front_mag_lev/year$year-$jobnum.txt
 done
done

