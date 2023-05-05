#<ctrl v><tab> to do the tab
echo "sorting internally"
sort -t"	" -k19,20 scored_body_mag2021.tsv | uniq > scored_body_mag_sorted2021.tsv
echo "picking best for each pat/mag/line"
perl findbest_match.pl scored_body_mag_sorted2021.tsv > scored_body_mag_bestonly2021.tsv
#rm -f scored_body_mag_sorted2021.tsv
echo "picking best whether grobid or us"
cat scored_body_mag_bestonly2021.tsv | cut -f1,2,10,19,21 | sort -k4,4 -k3,3 -k2,2 | perl findbestofbest_grobid.pl > scored_body_mag_bestonlywgrobid2021.tsv
