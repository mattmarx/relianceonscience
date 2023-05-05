echo "" > extractcitestopatentsfromgrobidoutputwindow_2020.txt
for x in {10001..10013}
do
  perl $NPL_BASE/nplmatch/grobid/extractcitestopatentsfromgrobid.pl $NPL_BASE/nplmatch/grobid/window/window_2020/window_2020OUT/grobidwindowoutput-$x >> extractcitestopatentsfromgrobidoutputwindow_2020.txt
done
