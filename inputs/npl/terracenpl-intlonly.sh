#/bin/bash -x
# combined npls
for year in {1800..2018}
do
 echo "looking for papers published in year $year"
 cat international_npl_clean.tsv | grep "[^0-9]$year[^0-9]" > nplbyrefyear/nplc_$year.tsv 
done
# hack for the NPLs that don't have a year
echo "now collect the non-nonsci NPLS without years and call them 1799"
 cat international_npl_clean.tsv | perl nplnoyear.pl > nplbyrefyear/nplc_1799int.tsv
