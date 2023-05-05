#!/bin/bash

### Author: Joshua Chu
### Date: February 20, 2023

### this scripts sorts the concatenated scored files and picks the "best of the best" between
### the heuristics approach and grobid approach

### command structure: sh sort_scored.sh <front or body> <oa or mag> <annual or batch>


### input year from config file
year=$(perl $NPL_BASE/nplmatch/config.pl)

frontorbody=$1
dbase=$2
varname=$3

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
 echo "You are missing a user input. The command structure is: sh sort_scored.sh <front or body> <oa or mag> <annual or batch>"
 exit

fi

if [ $varname == "annual" ]
then
 filedir=$(eval echo "$NPL_BASE/nplmatch/process_matches/scoredresults/scored_${frontorbody}_${dbase}_${year}annualpenalty.tsv")
 savefile="scored_${frontorbody}_${dbase}_${year}annualsorted.tsv"
 savefile1="scored_${frontorbody}_${dbase}_${year}annualbestonly.tsv"
 savefile2="scored_${frontorbody}_${dbase}_${year}annualbestonlywgrobid.tsv"

 if [ $frontorbody == "front" ]
 then

  echo "sorting internally"
  sed '1d' $filedir | sort -t$'\t' -k19,20 | uniq > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile

  echo "picking best"
  perl findbest_match.pl $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1

 elif [ $frontorbody == "body" ]
 then

  echo "sorting internally"
  sed '1d' $filedir | sort -t$'\t' -k19,20 | uniq > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile

  echo "picking best for each pat/mag/line"
  findbest_match.pl $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1

  echo "picking best whether grobid or us"
  cat $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1 | cut -f1,2,10,19,21 | sort -k4,4 -k3,3 -k2,2 | \
  $NPL_BASE/nplmatch/process_matches/findbestofbest_grobid.pl > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile2
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile2

 fi

elif [ $varname == "batch" ]
then
 filedir=$(eval echo "$NPL_BASE/nplmatch/process_matches/scoredresults/scored_${frontorbody}_${dbase}_${year}batchpenalty.tsv")
 savefile="scored_${frontorbody}_${dbase}_${year}batchsorted.tsv"
 savefile1="scored_${frontorbody}_${dbase}_${year}batchbestonly.tsv"
 savefile2="scored_${frontorbody}_${dbase}_${year}batchbestonlywgrobid.tsv"

 if [ $frontorbody == "front" ]
 then

  echo "sorting internally"
  sed '1d' $filedir | sort -t$'\t' -k19,20 | uniq > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile

  echo "picking best"
  perl findbest_match.pl $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1

 elif [ $frontorbody == "body" ]
 then

  echo "sorting internally"
  sed '1d' $filedir | sort -t$'\t' -k19,20 | uniq > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile

  echo "picking best for each pat/mag/line"
  perl findbest_match.pl $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1

  echo "picking best whether grobid or us"
  cat $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile1 | cut -f1,2,10,19,21 | sort -k4,4 -k3,3 -k2,2 | \
  perl $NPL_BASE/nplmatch/process_matches/findbestofbest_grobid.pl > $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile2
  chmod 777 $NPL_BASE/nplmatch/process_matches/scoredresults/$savefile2

 fi
fi
