#!/bin/bash
# hack for the NPLs that don't have a year
echo "now collect the non-nonsci NPLS without years and call them 1799"
 cat grobidwindowfulltextparsed_lc.txt | perl nplnoyear.pl > nplbyrefyear/nplc_1799.tsv
