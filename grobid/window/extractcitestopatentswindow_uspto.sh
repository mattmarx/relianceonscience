echo "" > window_uspto2020/extractcitestopatentsgrobid_uspto2020.txt
for x in {10001..10010}
do
  perl ../extractcitestopatentsfromgrobid.pl window_uspto2020/window_uspto2020OUT/grobidwindowoutput-$x >> window_uspto2020/extractcitestopatentsgrobid_uspto2020.txt
done
sort -u window_uspto2020/extractcitestopatentsgrobid_uspto2020.txt > window_uspto2020/extractcitestopatentsgrobidsorted_uspto2020.txt
rm window_uspto2020/extractcitestopatentsgrobid_uspto2020.txt
