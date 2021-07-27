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

 # RUN ALL THE STAGING SCRIPTS AND THEN SLEEP FOR 20 MINUTES.  THESE MUST START BEFORE THE MAIN JOBS FINISH.
 # STAGE 1 SCRIPTS
 # Run Stage 1 staging script for bt_${databbrev}_${locabbrev} (Titles)
 qsub -N S1T${databbrev}_${locabbrev} -l h_rt=96:00:00 $NPL_BASE/nplmatch/stagejobs.pl bt_${databbrev}_${locabbrev}
 # Run Stage 1 staging script for bc_${databbrev}_${locabbrev} (Pagevol)
 qsub -N S1C${databbrev}_${locabbrev} -l h_rt=96:00:00 $NPL_BASE/nplmatch/stagejobs.pl bc_${databbrev}_${locabbrev}
 # Run Stage 1 staging script for bj_${databbrev}_${locabbrev} (Journals)
 qsub -N S1J${databbrev}_${locabbrev} -l h_rt=24:00:00 $NPL_BASE/nplmatch/stagejobs.pl bj_${databbrev}_${locabbrev}
 # STAGE 2 SCRIPTS
 # Run Stage 2 staging script for xt_${databbrev}_${locabbrev}.  Must run as long as longest Stage 1 + longest Stage 2 scripts.
 qsub -N S2T${databbrev}_${locabbrev} -l h_rt=192:00:00 $NPL_BASE/nplmatch/stagejobs.pl xt_${databbrev}_${locabbrev}
 # Run Stage 2 staging script for xc_${databbrev}_${locabbrev}.  Must run as long as longest Stage 1 + longest Stage 2 scripts.
 qsub -N S2C${databbrev}_${locabbrev} -l h_rt=120:00:00 $NPL_BASE/nplmatch/stagejobs.pl xc_${databbrev}_${locabbrev}
 # Run Stage 2 staging script for xj_${databbrev}_${locabbrev}.  Must run as long as longest Stage 1 + longest Stage 2 scripts.
 qsub -N S2J${databbrev}_${locabbrev} -l h_rt=120:00:00 $NPL_BASE/nplmatch/stagejobs.pl xj_${databbrev}_${locabbrev}
 # STAGE 3 SCRIPTS
 # Run Stage 3 staging script for st_${databbrev}_${locabbrev}.  Must run as long as longest Stage 1 + longest Stage 2 scripts + longest Stage 3 scripts.
 qsub -N S3T${databbrev}_${locabbrev} -l h_rt=240:00:00 $NPL_BASE/nplmatch/stagejobs.pl st_${databbrev}_${locabbrev}
 # Run Stage 3 staging script for sc_${databbrev}_${locabbrev}.  Must run as long as longest Stage 1 + longest Stage 2 scripts + longest Stage 3 scripts.
 qsub -N S3C${databbrev}_${locabbrev} -l h_rt=160:00:00 $NPL_BASE/nplmatch/stagejobs.pl sc_${databbrev}_${locabbrev}
 # Run Stage 3 staging script for xc_${databbrev}_${locabbrev}.  Must run as long as longest Stage 1 + longest Stage 2 scripts.
 qsub -N S3J${databbrev}_${locabbrev} -l h_rt=160:00:00 /projectnb/marxnsf1/dropbox/bigdata/nplmatch/stagejobs.pl sj_${databbrev}_${locabbrev}
 sleep 30m

cd $NPL_BASE/nplmatch/
 # TITLE MATCHES SECTION
 cd splittitle_patent
 cd ../splittitle_articles
 # clean out title-based rules dir (not nec.)
 #####rm -f year_regex_scripts_front_mag_lev/*.pl
 rm -f year_regex_scripts_${loc}_${data}_lev/*.pl

 #build title-based rules, waiting on splittitle_patent

 if [ "$loc" = "front" ]; then
  # Run bt_${databbrev}_${locabbrev} 1799 script (Stage 1).  Leaving in the hold on patent but that is not part of this script.
  qsub -V -hold_jid splittitle_patent_$data sge_buildtitleregex1799_front_${data}_lev.sh
 fi
 # Run bt_${databbrev}_${locabbrev} scripts (Stage 1).  Leaving in the hold on patent but that is not part of this script.
 qsub -V -hold_jid splittitle_patent_$data sge_buildtitleregex_${loc}_${data}_lev.sh

 #run array of the title-based rules, waiting on buildtitles
 #####rm -f year_regex_output_front_mag_lev/*.txt
 rm -f year_regex_output_${loc}_${data}_lev/*.txt
 # Run xt_${databbrev}_${locabbrev} script (Stage 2).
 qsub -V -hold_jid S1T${databbrev}_${locabbrev} set_sge_running_${loc}_${data}_lev.sh
 ## clean out title-based results (nec.! bc/ sge appends)
 rm -f year_regex_scored_${data}_${loc}_lev/*.txt

 # Run st_${databbrev}_${locabbrev} script (Stage 3).
 qsub -V -hold_jid S2T${databbrev}_${locabbrev} set_sge_scoring_${loc}_${data}_lev.sh


 # PAGEVOL MATCHES SECTION
 cd ../splitpagevol_patent
 #qsub -V -N splitpagevol_patent_$1 sge_splitpagevol_front.sh
#only need this once for wos+mag
 #qsub -V -N splitpagevol_patent_$1 sge_splitpagevol_front.s lskkkkkkkk
 cd ../splitpagevol_articles
 #####rm -f year_regex_scripts_front_mag_lev/*.pl
 rm -f year_regex_scripts_${loc}_${data}/*.pl

 if [ "$loc" = "front" ]; then
  # Run bc_${databbrev}_${locabbrev} 1799 script (Stage 1).  Leaving in the hold on patent but that may not work.
  qsub -V -hold_jid splitpagevol_patent_mag sge_buildsplitregex1799_${loc}_${data}_lev.sh
 fi
 # Run bc_${databbrev}_${locabbrev} 1799 script (Stage 1).  Leaving in the hold on patent but that may not work.
 qsub -V -hold_jid splitpagevol_patent_mag sge_buildsplitregex_${loc}_${data}_lev.sh
 rm -f year_regex_output_front_${data}_${loc}_lev/*.txt

 # Run xc_${databbrev}_${locabbrev} script (Stage 2).
 qsub -V -hold_jid S1C${databbrev}_${locabbrev} set_sge_running_${loc}_${data}_lev.sh
 ## clean out nontitle-based results (nec.! bc/ sge appends)
 rm -f year_regex_scored_${loc}_${data}_lev/*.txt

 # Run sc_${databbrev}_${locabbrev} script (Stage 3).
 qsub -V -hold_jid S2C${databbrev}_${locabbrev} set_sge_scoring_${loc}_${data}_lev.sh
 

 # JOURNAL MATCHES SECTION
 # do the splitjournal_patent thing if you haven't already
 cd ../splitjournal_patent
 #
 cd ../splitjournal_articles
 rm -f year_regex_scripts_${loc}_${data}/*.pl

 # Run bj_${databbrev}_${locabbrev} scripts (Stage 1).  Leaving in the hold on patent but that is not part of this script.
 qsub -V -hold_jid splitjournal sge_buildjournalregex_${loc}_${data}.sh

 # run array of journal-based rules
 rm -f year_regex_output_${loc}_${data}/*.txt
 # Run xj_${databbrev}_${locabbrev} script (Stage 2).
 qsub -V -hold_jid S1J${databbrev}_${locabbrev} set_sge_running_${loc}_${data}.sh

 # score journal matches
 rm -f year_regex_scored_${loc}_${data}/*.txt
 # Run sj_${databbrev}_${locabbrev} script (Stage 3).
 qsub -V -hold_jid S2J${databbrev}_${locabbrev} set_sge_scoring_${loc}_${data}.sh

 # collect matches
 cd ../process_matches
 qsub -V -N co_${databbrev}_${locabbrev} -hold_jid S3T${databbrev}_${locabbrev},S3C${databbrev}_${locabbrev},S3J${databbrev}_${locabbrev} collectscoredmatches_${loc}_${data}.sh

 # sort matches
 qsub -V -N so_${databbrev}_${locabbrev} -hold_jid co_${databbrev}_${locabbrev} sort_scored_${loc}_${data}.sh
# export matches
 qsub -V -N exp_${databbrev}_${locabbrev} -hold_jid so_${databbrev}_${locabbrev} -j y -pe omp 8 -b y stata-mp -b do  exportmatches_${loc}_${data}
#[mattmarx@scc2 recall]$ qsub -j y -pe omp 8 -hold_jid ex_mg_bo -b y stata-mp -b do comparefrontbodytrends.do

 qsub -V -N exboth_${databbrev}_${locabbrev} -hold_jid exp_${databbrev}_${locabbrev} -j y -pe omp 8 -b y stata-mp -b do  exportmatches_both_${data}

else
 echo "need to specify 'mag' or 'wos' or 'pubmed' as argument 1 and 'front' or 'body' as argument 2"
fi
 else
 echo "need to specify 'mag' or 'wos' or 'pubmed' as argument 1 and 'front' or 'body' as argument 2"
 exit
fi
