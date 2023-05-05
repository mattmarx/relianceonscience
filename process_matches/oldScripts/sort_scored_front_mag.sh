#<ctrl v><tab> to do the tab
echo "sorting internally"
sort -t"	" -k19,20 scored_front_mag.tsv | uniq > scored_front_mag_sorted.tsv
echo "picking best"
findbest_match.pl scored_front_mag_sorted.tsv > scored_front_mag_bestonly.tsv
rm -f scored_front_mag_sorted.tsv
