#/bin/bash -x
# combined npls
#loop from 1900 (earliest WOS; MAG has back to 1800) until present
for year in {1800..2019}
do
 echo "looking for papers published in year $year"
 cat grobidoutputALL_parsed.txt | sed -e 's/^_*us//' | sed -e 's/^0*//' |  grep "[^0-9]$year[^0-9]" > nplbyrefyear/nplc_$year.tsv 
done
