for year in {1800..2020}
do
	echo "$year"
cat matchedjournals_magnameNODUPES.tsv | perl  terracenpl.pl $year > journalbodybyrefyear/journalbody_$year.tsv 

done
