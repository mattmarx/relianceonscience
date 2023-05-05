#<ctrl v><tab> to do the tab
echo "sorting internally"
sort -t"	" -k19,20 scored_front_mag2021.tsv | uniq > scored_front_mag_sorted2021.tsv
echo "picking best"
perl findbest_match.pl scored_front_mag_sorted2021.tsv > scored_front_mag_bestonly2021.tsv
#rm -f scored_front_mag_sorted.tsv
