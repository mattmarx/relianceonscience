#/bin/bash -x
# combined npls
echo "combining npls early and late"
#cat npl.1926.1975-lowercase.tsv uspto.citation.npl-lowercase.tsv > npl1926-2017.tsv
bash clean_2019.sh
bash clean_intl.sh
bash clean_pre1976.sh
cat npls.2019_clean.tsv pre_1976_npls_clean.tsv international_npl_clean_sorted.tsv npl.1926.2018-lowercaseOCRautofixnononsci.tsv | tr [:upper:] [:lower] | sort -u > frontpage19472019usintl.tsv

#loop from 1900 (earliest WOS; MAG has back to 1800) until present
for year in {1800..2019}
do
 echo "looking for papers published in year $year"
 ##cat frontpage19472019usintl.tsv | sed -e 's/^_*us//' | sed -e 's/^0*//' |  grep "[^0-9]$year[^0-9]" > nplbyrefyear/nplc_$year.tsv 
 cat frontpage19472019usintl.tsv |  grep "[^a-z0-9\-]$year[^0-9\-]" > nplbyrefyear/front_$year.tsv 
done
# hack for the NPLs that don't have a year
echo "now collect the non-nonsci NPLS without years and call them 1799"
 cat frontpage19472019usintl.tsv | perl nplnoyear.pl > nplbyrefyear/front_1799.tsv
 ##cat frontpage19472019usintl.tsv | sed -e 's/^_*us//' | sed -e 's/^0*//' | perl nplnoyear.pl > nplbyrefyear/nplc_1799.tsv
