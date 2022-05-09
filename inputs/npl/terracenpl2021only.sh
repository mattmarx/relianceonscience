#/bin/bash -x

#loop from 1900 (earliest WOS; MAG has back to 1800) until present
#for year in {1800..2018}
for year in {1800..2020}
do
 echo "looking for papers published in year $year"
 cat front2021_clean.tsv | grep "[^0-9]$year[^0-9]" > nplbyrefyear/front_$year.tsv 
done
# hack for the NPLs that don't have a year
echo "now collect the non-nonsci NPLS without years and call them 1799"
 cat front2021_clean.tsv | perl nplnoyear.pl > nplbyrefyear/front_1799.tsv
