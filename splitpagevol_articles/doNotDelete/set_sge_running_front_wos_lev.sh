#!/bin/bash

mkdir year_regex_output_front_wos_lev
mkdir year_regex_output_front_wos_lev/old
#mv year_regex_output_front_wos_lev/*.txt year_regex_output_front_wos_lev/old

for year in {1799..1799}
#for year in {1956..1956}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_scripts_front_wos_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  #qsub -N -N xc_ws_ft -hold_jid bc_ws_ft -o year_regex_output_front_wos_lev/year$year-$jobnum.txt -b y year_regex_scripts_front_wos_lev/year$year-$jobnum.pl
  qsub -N xc_ws_ft -hold_jid bc_ws_ft -l h_rt=96:00:00 -o year_regex_output_front_wos_lev/year$year-$jobnum.txt -b y year_regex_scripts_front_wos_lev/year$year-$jobnum.pl
 done
done


for year in {1900..2019}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_scripts_front_wos_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  #qsub -V -N xc_ws_ft -hold_jid bc_ws_ft -o year_regex_output_front_wos_lev/year$year-$jobnum.txt -b y year_regex_scripts_front_wos_lev/year$year-$jobnum.pl
  qsub -N xc_ws_ft -hold_jid bc_ws_ft -l h_rt=96:00:00 -o year_regex_output_front_wos_lev/year$year-$jobnum.txt -b y year_regex_scripts_front_wos_lev/year$year-$jobnum.pl
 done
done

