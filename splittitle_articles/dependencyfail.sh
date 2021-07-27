#!/bin/bash -x

 qsub -N xt_pm_ft set_sge_running_front_pubmed_lev.sh
 qsub -N st_pm_ft -hold_jid xt_pm_ft set_sge_scoring_front_pubmed_lev.sh

