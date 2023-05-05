#!/bin/bash -x
#011 start numbering at 1000 so we can kick off array jobs
TXT=".."
CODE="../code/"
PIECESDIR="years"


echo "building npl search strings "
cat ../../wos/txt/wosplpubinfo1955-2017.txt | awk -F "\t" '{ print $3 "\t" $1 "\t" $5 "\t" $7 "\t" $10 }' | perl buildnplsearchstrings003.pl > nplsearchstrings.pl




#for i in {2005..2017}
for i in {1955..2017}
 do
  echo "getting search strings for year $i"
  cat nplsearchstrings.pl | fgrep "W/ & /\\D$i" | sed -e "s@& /\\\D$i\\\D/ @@" > bywosyear/nplsearchstrings_$i.pl
 sed -i '1 i\while (<>) {\n' bywosyear/nplsearchstrings_$i.pl
 echo "}" >> bywosyear/nplsearchstrings_$i.pl
 done


