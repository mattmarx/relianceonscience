#!/bin/bash

#grep "^j " journalsandabbrevsshortsortspace.tsv | sed -e 's/ /\. /g' > journalsandabbrevspacedots.tsv
cat journalsandabbrevsshortsortspace.tsv journalsandabbrevspacedots.tsv ~/dropbox/bigdata/xwalkwosmag/magjournalabbrevs.tsv | sort -u > journalsandabbrevswithspacetogrep.tsv

# grobid has 'lc' marked for lowercase; others default to LC
cat ../fulltext_2020/bodynpl_digitized_lc.tsv ../fulltext_2020/grobidwindowparsed_uspto2020_lc.txt ../fulltext_2020/grobidwindowparsed_epo2020_lc.txt | fgrep --color=always -f journalsandabbrevswithspacetogrep.tsv | sort -u > matchedjournalscolorwithspace.tsv

cat  ../fulltext_2020/bodynpl_digitized_ulc.tsv ../fulltext_2020/grobidwindowparsed_uspto2020_ulc.txt ../fulltext_2020/grobidwindowparsed_epo2020_ulc.txt | fgrep --color=always -f journalsandabbrevsnospacetogrep.tsv | sort -u > matchedjournalscolornospace.tsv

cat matchedjournalscolorwithspace.tsv matchedjournalscolornospace.tsv | tr [:upper:] [:lower:] | sort -u > matchedjournalscolor.tsv

perl matchjournalabbrevstomagname.pl

cat matchedjournals_magname.tsv | sort -u > matchedjournals_magnameNODUPES.tsv

rm -f journalbodybyrefyear/*.tsv
terracejournal.sh
#qsub sge_terracejournalbody.sh
