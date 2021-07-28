echo "" > window_epo2020/extractcitestopatentsgrobid_epo2020.txt
for x in {10001..10003}
do
  perl ../extractcitestopatentsfromgrobid.pl window_epo2020/window_epo2020OUT/grobidwindowoutput-$x >> window_epo2020/extractcitestopatentsgrobid_epo2020.txt
done
sort -u window_epo2020/extractcitestopatentsgrobid_epo2020.txt > window_epo2020/extractcitestopatentsgrobidsorted_epo2020.txt 
rm window_epo2020/extractcitestopatentsgrobid_epo2020.txt
