#!/bin/bash -l

#$ -t 10001-10783
#$ -j y
#$ -N parsegrobid
#$ -l h_rt=12:00:00
#$ -P marxnsf1

chmod 664 $SGE_STDOUT_PATH
chmod 664 $SGE_STDERR_PATH


/projectnb/marxnsf1/dropbox/bigdata/nplmatch/grobid/parsegrobidoutput.pl /projectnb/marxnsf1/dropbox/bigdata/nplmatch/grobid/fulltext/fulltext_u20052019OUT/grobidfulltextoutput-$SGE_TASK_ID > /projectnb/marxnsf1/dropbox/bigdata/nplmatch/grobid/fulltext/fulltext_u20052019PARSED/grobidfulltextparsed-$SGE_TASK_ID


