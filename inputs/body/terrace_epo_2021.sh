mkdir fulltext_epo2021/bodybyrefyear
for year in {1800..2020}
#for year in {2015..2020}
do
        echo "doing $year"
        cat fulltext_epo2021/filtered-*  | perl terracenpl.pl $year > fulltext_epo2021/bodybyrefyear/body_$year.tsv
done
