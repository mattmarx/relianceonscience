#/bin/bash -x

for year in {1900..2019}
do
 echo "looking for papers published in year $year"
 cat wosplpubinfo1955-2019_filteredISS.txt | grep "^$year" | sed -e 's/\\//g' | sed -e 's/{//g' | sed -e 's/}//g' > wosbyyear/wos_$year.tsv 
done

