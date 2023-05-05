for year in {1800..2020}
do
	echo "buildtitleregex_byyear_front_lev $year"
	perl buildtitleregex_byyear_front_lev.pl mag $year
done
echo "1799"
perl buildtitleregex_byyear_front_lev.pl mag 1799
