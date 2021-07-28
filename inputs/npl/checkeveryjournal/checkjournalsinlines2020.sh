#!/bin/bash


grep "^j " journalsandabbrevsshortsortspace.tsv | sed -e 's/ /\. /g' > journalsandabbrevspacedots.tsv
cat journalsandabbrevsshortsortspace.tsv journalsandabbrevspacedots.tsv ../../../../xwalkwosmag/magjournalabbrevs.tsv | sort -u | tr [:upper:] [:lower:] > journalsandabbrevswithspacetogrep.tsv

cat ../front2020_clean.tsv  | sort -u | fgrep --color=always -f journalsandabbrevswithspacetogrep.tsv | sort -u > matchedjournalscolorwithspace.tsv

cat ../front2020_clean.tsv  | sort -u | fgrep --color=always -f journalsandabbrevsnospacetogrep.tsv | sort -u > matchedjournalscolornospace.tsv

cat matchedjournalscolorwithspace.tsv matchedjournalscolornospace.tsv | tr [:upper:] [:lower:] | sort -u > matchedjournalscolor.tsv

matchjournalabbrevstomagname.pl

cat matchedjournals_magname.tsv | sort -u > matchedjournals_magnameNODUPES.tsv
stop
rm -f journalbodybyrefyear/*.tsv
qsub sge_terracejournal.sh
