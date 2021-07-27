#!/bin/bash
####!/bin/bash

### #$ -j y
#SBATCH -o splitpagevol-%j.out


#SBATCH -J splitpagevol_body
### #$ -N splitpagevol_body


#SBATCH --depend=terracebody,terracemag,terracepubmed,terracewos
### #$ -hold_jid terracebody,terracemag,terracepubmed,terracewos

#SBATCH --wckey=marxnfs1
### #$ -P marxnsf1

#SBATCH --export=ALL
### #$ -V


### chmod 664 $SGE_STDOUT_PATH
# standard out is current directory unless you change it

### #$ -t 1800-2019
#SBATCH --array=0-220
YEAR_ID=$(( ($SLURM_ARRAY_TASK_ID + 1800) ))

perl $NPL_BASE/nplmatch/splitpagevol_patent/splitpagevol_body.pl $YEAR_ID
### $NPL_BASE/nplmatch/splitpagevol_patent/splitpagevol_body.pl $SGE_TASK_ID


