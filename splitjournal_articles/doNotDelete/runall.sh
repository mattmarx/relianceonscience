#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH -n 1
#SBATCH --array=0-220
YEAR_ID=1800
#SBATCH -p large
perl /home/fs01/nplmatchroot/nplmatch/inputs/body/fulltext_2020/terracenpl.pl bodynpl_digitized_lc.tsv > /home/fs01/nplmatchroot/nplmatch/inputs/body/bodybyrefyear/body_1802.tsv
