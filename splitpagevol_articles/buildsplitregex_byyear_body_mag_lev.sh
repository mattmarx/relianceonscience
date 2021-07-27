for year in {1800..2020}
do
	echo "buildsplitregex_byyear_body_lev $year"
	perl buildsplitregex_byyear_body_lev.pl mag $year
done
