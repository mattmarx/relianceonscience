#!/bin/bash
#SBATCH -p large
### #!/bin/bash -l

#SBATCH --array=0-12
PARAS_ID=$(( ($SLURM_ARRAY_TASK_ID + 10001) ))
### #$ -t 10001-10410

### #$ -j y

#SBATCH -J
### #$ -N win_oneline

#SBATCH -t 12:00:00
### #$ -l h_rt=12:00:00

#SBATCH --wckey=marxnfs1
### $ -P marxnsf1

### chmod 664 $SGE_STDOUT_PATH
### chmod 664 $SGE_STDERR_PATH

perl $NPL_BASE/nplmatch/grobid/window/onepatperlinewindowjeren.pl < $NPL_BASE/nplmatch/inputs/body/uspto_2020/windows-$PARAS_ID > $NPL_BASE/nplmatch/grobid/window/window_uspto2020/windowscombined-$PARAS_ID
### /projectnb/marxnsf1/dropbox/bigdata/nplmatch/grobid/window/onepatperlinewindow.pl /projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/fulltext_gocr/windows-$SGE_TASK_ID > /projectnb/marxnsf1/dropbox/bigdata/nplmatch/grobid/window/window_gocr/grobidwindowinput-$SGE_TASK_ID
