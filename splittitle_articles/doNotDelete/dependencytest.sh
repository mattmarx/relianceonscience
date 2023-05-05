#!/bin/bash -x

# Run Stage Monitoring Script(s)
qsub -N stage1 /projectnb/marxnsf1/dropbox/bigdata/nplmatch/stagejobs.pl xt_pm_ft

# Run generated scripts
# xt_pm_ft
qsub set_sge_running_front_pubmed_lev.sh

# Do Scoring of generated output files.
# st_pm_ft
qsub -hold_jid stage1 set_sge_scoring_front_pubmed_lev.sh

