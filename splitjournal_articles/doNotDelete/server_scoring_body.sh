#!/bin/bash

FRONTORBODY=body
ARTICLEDB=oa # mag or oa or wos

FRONTORBODY="body"
ARTICLEDB="oa"

for ((i=1800; i<=2022; i++))
do

 for eachfile in $(ls year_regex_output_${FRONTORBODY}_${ARTICLEDB}/year${i}-*)
 do
  echo "doing ${eachfile:26}"
  module load perl5-libs
  perl ../process_matches/score_matches.pl $eachfile > ./year_regex_scored_${FRONTORBODY}_${ARTICLEDB}/${eachfile:26}
  chmod 777 ./year_regex_scored_${FRONTORBODY}_${ARTICLEDB}/${eachfile:26}

 done
done

