#/bin/bash -x


echo "getting fulltext digitized"
cat  uspto_2020/filtered* epo_2020/filtered* | sed -e 's/^__US0*/__US/' | sort -u > fulltext_2020/bodynpl_digitized_ulc.tsv
#cat  fulltext_g19762004/*filtered* fulltext_u20052019/*filtered* | tr [:upper:] [:lower:] | sort -u > bodynpl_digitized.tsv
# gather the OCR and run them through dash handling


echo "combine all, preserving case"
cat fulltext_2020/bodynpl_digitized_ulc.tsv | tr [:upper:] [:lower:] > fulltext_2020/bodynpl_digitized_lc.tsv
