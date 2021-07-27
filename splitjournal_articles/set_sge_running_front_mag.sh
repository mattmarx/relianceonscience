#!/bin/bash
rm -f year_regex_output_front_mag/*.txt
for year in {1800..2019}
#for year in {1956..1956}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_scripts_front_mag/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 #echo "qsub -t 1000-$maxnum sge_runlevpieces.sh $year"
 #for jobnum in {1000..$maxnum}
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  qsub -N xj_mg_ft -hold_jid bj_mg_ft -o year_regex_output_front_mag/year$year-$jobnum.txt -b y year_regex_scripts_front_mag/year$year-$jobnum.pl
 done
done

