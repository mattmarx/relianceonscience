#<ctrl v><tab> to do the tab
echo "sorting internally"
sort -t"	" -k19,20 scored_body_wos.tsv | uniq > scored_body_wos_sorted.tsv
echo "picking best"
findbest_match.pl scored_body_wos_sorted.tsv > scored_body_wos_bestonly.tsv
rm -f scored_body_wos_sorted.tsv
cat scored_body_wos_bestonly.tsv | cut -f1,2,10,19,21 | sort -k4,4 -k3,3 -k2,2 | findbestofbest_grobid.pl > scored_body_wos_bestonlywgrobid.tsv

