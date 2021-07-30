for year in {1800..2020}}
do
	echo "doing $year"
	cat bodynpl_digitized_lc.tsv grobidwindowparsed_epo2020_lc.txt grobidwindowparsed_uspto2020_lc.txt | perl ../terracenpl.pl $year > bodybyrefyear/body_$year.tsv
done

