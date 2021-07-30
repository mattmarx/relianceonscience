for year in {1800..2020}}
do
	echo "doing $year"
	cat fulltext_2020/bodynpl_digitized_lc.tsv fulltext_2020/grobidwindowparsed_epo2020_lc.txt fulltext_2020/grobidwindowparsed_uspto2020_lc.txt | perl terracenpl.pl $year > fulltext_2020/bodybyrefyear/body_$year.tsv
done

