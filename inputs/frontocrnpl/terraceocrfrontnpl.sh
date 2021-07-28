#/bin/bash -x
# combined npls
rm -f ocrnplbyrefyear/front_*.tsv
for year in {1800..1979}
do
 echo "looking for papers published in year $year"
 cat *.tsv | tr [:upper:] [:lower:] | sort -u |    grep "[^a-z0-9\-]$year[^0-9\-]" > ocrnplbyrefyear/front_$year.tsv 
done
 cat *.tsv | tr [:upper:] [:lower:] | sort -u |  perl nplnopre1980year.pl > ocrnplbyrefyear/front_1799.tsv

