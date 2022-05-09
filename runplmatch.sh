#!/bin/bash 

echo "article dataset: $1"
echo "reference location: $2"
     
# do either wos or mag but not both; fail if neither specified
if [ "$1" = "mag" ] || [ "$1" = "wos" ] || [ "$1" = "pubmed" ]; then
 if [ "$2" = "front" ] || [ "$2" = "body" ]; then
  data=$1
  if [ "$data" = "mag" ]; then databbrev="mg"; fi
  if [ "$data" = "wos" ]; then databbrev="ws"; fi
  if [ "$data" = "pubmed" ]; then databbrev="pm"; fi
  echo "databbrev = ${databbrev}"
  loc=$2
  if [ "$loc" = "front" ]; then locabbrev="ft"; fi
  if [ "$loc" = "body" ]; then locabbrev="bd"; fi
  echo "locabbrev = ${locabbrev}"
  echo "doing ${loc} matches for ${data}"
 cd splittitle_patent
 cd ../splittitle_articles
 # clean out title-based rules dir (not nec.)
 #####rm -f year_regex_scripts_front_mag_lev/*.pl
 rm -f year_regex_scripts_${loc}_${data}_lev/*.pl
 #build title-based rules, waiting on splittitle_patent
 #####qsub -N bmft -hold_jid splittitle_patent_mag sge_buildtitleregex1799_front_mag_lev.sh
 if [ "$loc" = "front" ]; then
  #####qsub -N bmft -hold_jid splittitle_patent_mag sge_buildtitleregex1799_front_mag_lev.sh
  qsub -N bt_${databbrev}_${locabbrev} -hold_jid splittitle_patent_$data sge_buildtitleregex1799_front_${data}_lev.sh
 fi
 #####qsub -N bmft -hold_jid splittitle_patent_mag sge_buildtitleregex_front_mag_lev.sh
 qsub -N bt_${databbrev}_${locabbrev} -hold_jid splittitle_patent_$data sge_buildtitleregex_${loc}_${data}_lev.sh
 #run array of the title-based rules, waiting on buildtitles
 #####rm -f year_regex_output_front_mag_lev/*.txt
 rm -f year_regex_output_${loc}_${data}_lev/*.txt
 qsub -N xt_${databbrev}_${locabbrev} -hold_jid bt_${databbrev}_${locabbrev} set_sge_running_${loc}_${data}_lev.sh
 ## clean out title-based results (nec.! bc/ sge appends)
 rm -f year_regex_scored_${data}_${loc}_lev/*.txt
 qsub -N st_${databbrev}_${locabbrev}  -hold_jid xt_${databbrev}_${locabbrev}  set_sge_scoring_${loc}_${data}_lev.sh

 # run the non-title matches
 cd ../splitpagevol_patent
 #qsub -N splitpagevol_patent_$1 sge_splitpagevol_front.sh
#only need this once for wos+mag
 #qsub -N splitpagevol_patent_$1 sge_splitpagevol_front.s lskkkkkkkk
 cd ../splitpagevol_articles
 #####rm -f year_regex_scripts_front_mag_lev/*.pl
 rm -f year_regex_scripts_${loc}_${data}/*.pl
 if [ "$loc" = "front" ]; then
  qsub -N bc_${databbrev}_${locabbrev} -hold_jid splitpagevol_patent_mag sge_buildsplitregex1799_${loc}_${data}_lev.sh
 fi
 qsub -N bc_${databbrev}_${locabbrev} -hold_jid splitpagevol_patent_mag sge_buildsplitregex_${loc}_${data}_lev.sh
 rm -f year_regex_output_front_${data}_${loc}_lev/*.txt
 qsub -N xc_${databbrev}_${locabbrev} -hold_jid bc_${databbrev}_${locabbrev} set_sge_running_${loc}_${data}_lev.sh
 ## clean out nontitle-based results (nec.! bc/ sge appends)
 rm -f year_regex_scored_${loc}_${data}_lev/*.txt
 qsub -N sc_${databbrev}_${locabbrev} -hold_jid xc_${databbrev}_${locabbrev} set_sge_scoring_${loc}_${data}_lev.sh
 
 #run the journal matches
 # do the splitjournal_patent thing if you haven't already
 cd ../splitjournal_patent
 #
 cd ../splitjournal_articles
 rm -f year_regex_scripts_${loc}_${data}/*.pl
 qsub -N bj_${databbrev}_${locabbrev} -hold_jid splitjournal sge_buildjournalregex_${loc}_${data}.sh
 # run array of journal-based rules
 rm -f year_regex_output_${loc}_${data}/*.txt
 qsub -N xj_${databbrev}_${locabbrev} -hold_jid bj_${databbrev}_${locabbrev} set_sge_running_${loc}_${data}.sh
 # score
 rm -f year_regex_scored_${loc}_${data}/*.txt
 qsub -N sj_${databbrev}_${locabbrev} -hold_jid xj_${databbrev}_${locabbrev} set_sge_scoring_${loc}_${data}.sh

 # collect matches
 cd ../process_matches
 qsub -hold_jid st_${databbrev}_${locabbrev},sc_${databbrev}_${locabbrev},sj_${databbrev}_${locabbrev} collectscoredmatches_${loc}_${data}.sh

else
 echo "need to specify 'mag' or 'wos' or 'pubmed' as argument 1 and 'front' or 'body' as argument 2"
fi
 else
 echo "need to specify 'mag' or 'wos' or 'pubmed' as argument 1 and 'front' or 'body' as argument 2"
 exit
fi
