echo "" > window_uspto2020/parsegrobidoutput_uspto2020.txt
for x in {10001..10010}
do
  perl $NPL_BASE/nplmatch/grobid/parsegrobidoutput.pl $NPL_BASE/nplmatch/grobid/window/window_uspto2020/window_uspto2020OUT/grobidwindowoutput-$x >> window_uspto2020/parsegrobidoutput_uspto2020.txt
done
sort -u window_uspto2020/parsegrobidoutput_uspto2020.txt > window_uspto2020/parsegrobidoutputsorted_uspto2020.txt
rm window_uspto2020/parsegrobidoutput_uspto2020.txt
