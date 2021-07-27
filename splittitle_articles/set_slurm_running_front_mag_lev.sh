#!/bin/bash

mkdir year_regex_output_front_mag_lev
mkdir year_regex_output_front_mag_lev/old
#mv year_regex_output_front_mag_lev/*.txt year_regex_output_front_mag_lev/old

#for year in {1799..2019}
for year in {1801..1801}
#for year in {1956..1956}
do
 echo
 echo "doing $year."
 num=$(ls -l year_regex_scripts_front_mag_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))
 for jobnum in $(eval echo "{1000..$maxnum}")
 do
  #qsub -N xt_mg_ft -hold_jid bt_mg_ft -o year_regex_output_front_mag_lev/year$year-$jobnum.txt -b y year_regex_scripts_front_mag_lev/year$year-$jobnum.pl
  srun -p large perl year_regex_scripts_front_mag_lev/year$year-$jobnum.pl >  year_regex_output_front_mag_lev/year$year-$jobnum.txt 
  #qsub -N xt_mg_ft -hold_jid bt_mg_ft -l h_rt=96:00:00 -o year_regex_output_front_mag_lev/year$year-$jobnum.txt -b y year_regex_scripts_front_mag_lev/year$year-$jobnum.pl
 done
done

