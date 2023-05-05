for year in {1800..2020}
do
	echo "buildtitleregex_byyear_body_lev $year"
	perl buildtitleregex_byyear_body_lev.pl mag $year
done
