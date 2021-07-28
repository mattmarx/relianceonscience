#!/bin/bash -x

cat ../../../wos/txt/wosplpubinfo.txt | awk -F "\t" '{ print $3 "\t" $1 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $11 "\t" $14 "\t" $4 }' |  iconv -f UTF8 -t US-ASCII//TRANSLIT | tr [:upper:] [:lower:] | sort -u > wosplpubinfo1955-2019_filteredISS.txt

