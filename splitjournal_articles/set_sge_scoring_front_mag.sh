#!/bin/bash
rm -f year_regex_scored_front_mag/*.txt
for year in {1800..2019}
#for year in {1976..1976}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_output_front_mag/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -V -P marxnsf1 -N sj_mg_ft -hold_jid xj_mg_ft -o year_regex_scored_front_mag/scored$year-$jobnum.txt  -b y ../process_matches/score_matches.pl year_regex_output_front_mag/year$year-$jobnum.txt
 done
done

