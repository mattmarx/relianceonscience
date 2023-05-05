#!/bin/bash

### Author: Joshua Chu
### Date: February 20, 2023

### this scripts collects the scored files from the split{journal,title,pagevol}_articles directories
### and concatenates them into a single file. The user must specify if the front or body scored results
### are being processed. Further, the database utilized to construct the scored data must also be
### specified. Constructing the script as shown below reduced the number of scripts required to collect
### the data and combine the results. If desired, the original scripts can be found in the Old/ directory

### command structure: sh collectscoredmatches.sh


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

frontorbody="body" # front or body
dbase="oa" # oa or mag

echo "Are you doing an annual update or batch?"

read varname

echo "Are you doing front or body?"

read varname1

if [[ $varname != "annual" ]] && [[ $varname != "batch" ]]
then
 echo "Please enter a valid option: <annual or batch>"
 exit

fi

if [[ $varname1 != "front" ]] && [[ $varname1 != "body" ]]
then
 echo "Please enter a valid option: <front or body>"
 exit

fi


if [ $varname == "annual" ]
then
 scoredir=$(eval echo "year_regex_scored_${varname1}_${dbase}")
 savefile="scored_${varname1}_${dbase}_${year}annual.tsv"

 cat $NPL_BASE/nplmatch/splittitle_articles/$scoredir/*.txt $NPL_BASE/nplmatch/splitpagevol_articles/$scoredir/*.txt $NPL_BASE/nplmatch/splitjournal_articles/$scoredir/*.txt | \
 sed -e "s/__us/__US/" | sed -e "s/_u_s/__US/" | grep -v 'ReferenceSource' | sort -u > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile
 chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile

elif [ $varname == "batch" ]
then
 scoredir=$(eval echo "year_regex_scored_${varname1}_${dbase}")
 savefile="scored_${varname1}_${dbase}_${year}batch.tsv"

 cat $NPL_BASE/nplmatch/splittitle_articles/$scoredir/*.txt $NPL_BASE/nplmatch/splitpagevol_articles/$scoredir/*.txt $NPL_BASE/nplmatch/splitjournal_articles/$scoredir/*.txt | \
 sed -e "s/__us/__US/" | sed -e "s/_u_s/__US/" | grep -v 'ReferenceSource' | sort -u > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile
 chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile

fi
