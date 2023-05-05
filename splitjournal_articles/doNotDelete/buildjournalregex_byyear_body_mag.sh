for year in {1800..2020}
do
	echo "buildtitleregex_byyear_body $year"
	perl buildjournalregex_byyear_body.pl mag $year
done
