for year in {1800...2021{}}
 do
 #echo "doing $year"
 cat ./fulltext_epo/filtered-100* | perl terracenpl.pl $year > ./testing/bodybyrefyear/body_$year.tsv
done

