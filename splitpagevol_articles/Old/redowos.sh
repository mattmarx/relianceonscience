#!/bin/bash -x

cat ../../wos/txt/wosplpubinfo1955-2017.txt | awk -F "\t" '{ print $3 "\t" $1 "\t" $5 "\t" $6 "\t" $7 "\t" $10 "\t" $13 "\t"}' > wosplpubinfo1955-2017_filteredISS.txt

