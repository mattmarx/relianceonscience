#!/usr/local/bin/perl

# nothing of importance - Josh added this to test
#
$NPL_BASE=$ENV{'NPL_BASE'};

#$INPUTDIR_PATENTS_FRONT="$NPL_BASE" . "/nplmatch/inputs/frontocrnpl/ocrnplbyrefyear/"; # Input files of format front_YYYY.tsv, 1947-1975 only, to account for google missing these
#$INPUTDIR_PATENTS_FRONT="$NPL_BASE" . "/rsp_prod/data/processed/front/front_by_refyear/"; # Input files of format front_YYYY.tsv
$INPUTDIR_PATENTS_FRONT="$NPL_BASE" . "/nplmatch/inputs/npl/nplbyrefyear/"; # Input files of format front_YYYY.tsv
$INPUTDIR_PATENTS_BODY="$NPL_BASE" . "/nplmatch/inputs/body/fulltext_2021j/bodybyrefyear/"; # Input files of format body_YYYY.tsv
#$INPUTDIR_PATENTS_BODY="$NPL_BASE" . "/nplmatch/inputs/body/fulltext_2021j/bodybyrefyear/"; # Input files of format body_YYYY.tsv
#$INPUTDIR_PATENTS_BODY="$NPL_BASE" . "/nplmatch/inputs/body/fulltext_epo/bodybyrefyear/"; # Input files of format body_YYYY.tsv
#$INPUTDIR_PATENTS_BODY="$NPL_BASE" . "/nplmatch/inputs/body/bodybyrefyear/"; # Input files of format body_YYYY.tsv
#$INPUTDIR_JOURNAL_FRONT="$NPL_BASE" . "/rsp_prod/data/processed/journals/journalfrontbyrefyear/"; # Input files of format journalfront_YYYY.tsv
$INPUTDIR_JOURNAL_FRONT="$NPL_BASE" . "/nplmatch/inputs/npl/checkeveryjournal/journalbyrefyear_j/"; # Input files of format journalfront_YYYY.tsv
$INPUTDIR_JOURNAL_BODY="$NPL_BASE" . "/nplmatch/inputs/body/fulltext_2021j/checkeveryjournal/journalbodybyrefyear/"; # Input files of format journalbody_YYYY.tsv
$INPUTDIR_WOS="$NPL_BASE" . "/nplmatch/inputs/wos/wosbyyear/"; # Input files of format wos_YYYY.tsv
$INPUTDIR_MAG="$NPL_BASE" . "/nplmatch/inputs/mag/magbyyear/"; # Input files of format mag_YYYY.tsv

$INPUTFILE_1799_WOS="$NPL_BASE" . "/nplmatch/inputs/wos/wosplpubinfo1955-2019_filteredISS.txt"; 
$INPUTFILE_1799_MAG="$NPL_BASE" . "/nplmatch/inputs/mag/magoneline.tsv"; 

$NPL_MISC="$NPL_BASE" . "/nplmatch/misc_files/";

$PERL_LEVDAM_PATH="#!/usr/local/bin/perl";
#$PERL_LEVDAM_PATH="#!/share/pkg.7/perl/5.28.1/install/bin/perl";
