#!/bin/bash
rm -f year_regex_output_body_mag_lev/*.txt
rm -f arrayjob_sub_scripts/*.sh
for year in {1800..2019}
do
 echo
 echo "doing $year."

 num=$(ls -l year_regex_scripts_body_mag_lev/year$year-* | wc -l)
 echo "found $num files for $year."
 maxnum=$((num+999))

 if [ $maxnum -gt 1000 ]
 then
  echo "building and submitting array job"
  buildarrayscript.pl splittitle_articles body mag_lev $year
  qsub arrayjob_sub_scripts/array-$year.sh
 else
  echo "submitting single job"
  qsub -P marxnsf1 -N runtitle_body_mag$year -o year_regex_output_body_mag_lev/year$year-1000.txt -b y year_regex_scripts_body_mag_lev/year$year-1000.pl
 fi
done

