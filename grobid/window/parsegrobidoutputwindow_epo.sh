echo "" > window_epo2020/parsegrobidoutput_epo2020.txt
for x in {10001..10003}
do
  perl $NPL_BASE/nplmatch/grobid/parsegrobidoutput.pl $NPL_BASE/nplmatch/grobid/window/window_epo2020/window_epo2020OUT/grobidwindowoutput-$x >> window_epo2020/parsegrobidoutputwindow_epo2020.txt
done
sort -u window_epo2020/parsegrobidoutputwindow_epo2020.txt > window_epo2020/parsegrobidoutputwindowsorted_epo2020.txt
rm window_epo2020/parsegrobidoutputwindow_epo2020.txt
