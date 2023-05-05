for year in {1800..2020}
do
	echo "buildtitleregex_byyear_front $year"
	perl buildjournalregex_byyear_front.pl mag $year
done
