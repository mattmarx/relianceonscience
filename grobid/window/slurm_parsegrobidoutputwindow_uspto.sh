echo "" > window_uspto2020/parsegrobidoutputwindow_uspto2020.txt
for x in {10001..10010}
do
  perl $NPL_BASE/nplmatch/grobid/parsegrobidoutput.pl $NPL_BASE/nplmatch/grobid/window/window_uspto2020/window_uspto2020OUT/grobidwindowoutput-$x >> window_uspto2020/parsegrobidoutputwindow_uspto2020.txt
done
sort -u window_uspto2020/parsegrobidoutputwindow_uspto2020.txt  > window_uspto2020/grobidwindowparsed_uspto2020_ulc.txt
rm window_uspto2020/parsegrobidoutputwindow_uspto2020.txt
cat window_uspto2020/grobidwindowparsed_uspto2020_ulc.txt | tr [:upper:] [:lower:] | sort -u > window_uspto2020/grobidwindowparsed_uspto2020_lc.txt
cp window_uspto2020/grobidwindowparsed_uspto2020_ulc.txt window_uspto2020/grobidwindowparsed_uspto2020_lc.txt ../../inputs/body/fulltext_2020



