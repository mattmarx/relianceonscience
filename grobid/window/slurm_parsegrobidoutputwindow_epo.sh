echo "" > window_epo2020/parsegrobidoutputwindow_epo2020.txt
for x in {10001..10003}
do
  perl $NPL_BASE/nplmatch/grobid/parsegrobidoutput.pl $NPL_BASE/nplmatch/grobid/window/window_epo2020/window_epo2020OUT/grobidwindowoutput-$x >> window_epo2020/parsegrobidoutputwindow_epo2020.txt
done
sort -u window_epo2020/parsegrobidoutputwindow_epo2020.txt  > window_epo2020/grobidwindowparsed_epo2020_ulc.txt
rm window_epo2020/parsegrobidoutputwindow_epo2020.txt


# create a lowercase version for the non-journal match
cat window_epo2020/grobidwindowparsed_epo2020_ulc.txt | tr [:upper:] [:lower:] | sort -u > window_epo2020/grobidwindowparsed_epo2020_lc.txt
cp window_epo2020/grobidwindowparsed_epo2020_ulc.txt window_epo2020/grobidwindowparsed_epo2020_lc.txt ../../inputs/body/fulltext_2020
