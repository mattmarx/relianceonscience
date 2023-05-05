#!/usr/local/bin/perl

#module load perl5-libs;

$NPL_BASE=$ENV{'NPL_BASE'};

#use Env::Modify 'source';
#source("/home/fs01/nplmatchroot/nplmatch/my_env.sh");
#
#print "FOO is $ENV{FOO}\n";  # expect: "123"
#print "There are $ENV{NUM_HOME_FILES} in the home dir\n";


#my $barfoo = $ENV{'FOO'};

### change the $CURRENTYR variable to the current year for new front and body patents
$CURRENTYR=2022;
print "$CURRENTYR\n";


### directories used in multiple scripts
#$INPUTDIR_PATENTS_FRONT="$NPL_BASE" . "/nplmatch/inputs/front/"; # this can no longer be used because the new server network includes subdirectories that allow multiple updates per year

$INPUTDIR_PATENTS_FRONT="$NPL_BASE" . "/nplmatch/inputs/front/$CURRENTYR/001/processed/frontbyrefyear/"; # Input files of format front_YYYY.tsv
$INPUTDIR_PATENTS_FRONTBATCH="$NPL_BASE" . "/nplmatch/inputs/front/googlebatchdownload/frontbyrefyear/"; # Input batch files of format front_YYYY.tsv from googlebatchdownloads 



$INPUTDIR_PATENTS_BODY="$NPL_BASE" . "/nplmatch/inputs/intext/"; # Input files of format body_YYYY.tsv
$INPUTDIR_PATENTS_BODYBATCH="$NPL_BASE" . "/nplmatch/inputs/intext/googlefulltext/fulltext/bodybyrefyear/"; # Input files of format body_YYYY.tsv from googlefulltext

$INPUTDIR_PATENT_DEPENDENCIES="$NPL_BASE" . "/nplmatch/inputs/patentsfiles/"; # Directory containing files perl scripts are dependent

#$INPUTDIR_PATENTS_FRONT="$NPL_BASE" . "/nplmatch/inputs/front/uspto_$YEAR/data/processed/nplbyrefyear/"; # Input files of format front_YYYY.tsv
#$INPUTDIR_PATENTS_BODY="$NPL_BASE" . "/nplmatch/inputs/body/uspto_$YEAR/data/processed/bodybyrefyear/"; # Input files of format body_YYYY.tsv

#$INPUTDIR_JOURNAL_FRONT="$NPL_BASE" . "/nplmatch/inputs/front/"; # this can no longer be used because the new server network includes subdirectories that allow multiple updates per year


$INPUTDIR_JOURNAL_FRONT="$NPL_BASE" . "/nplmatch/inputs/front/$CURRENTYR/001/processed/checkeveryjournal/journalbyrefyear/"; # Input files of format journalfront_YYYY.tsv
$INPUTDIR_JOURNAL_FRONTBATCH="$NPL_BASE" . "/nplmatch/inputs/front/googlebatchdownload/checkeveryjournal/journalbyrefyear/"; # Input batch files of format journalfront_YYYY.tsv from googlebatchdownloads

$INPUTDIR_JOURNAL_BODY="$NPL_BASE" . "/nplmatch/inputs/intext/"; # Input files of format journalbody_YYYY.tsv
$INPUTDIR_JOURNAL_BODYBATCH="$NPL_BASE" . "/nplmatch/inputs/intext/googlefulltext/checkeveryjournal/journalbodybyrefyear/"; # Input files of format journalbody_YYYY.tsv from googlefulltext

$INPUTDIR_WOS="$NPL_BASE" . "/nplmatch/inputs/wos/wosbyyear/"; # Input files of format wos_YYYY.tsv
$INPUTDIR_MAG="$NPL_BASE" . "/nplmatch/inputs/mag/magbyyear/"; # Input files of format mag_YYYY.tsv
$INPUTDIR_OA="$NPL_BASE" . "/nplmatch/inputs/openalex/openalexbyyear/"; # Input files of format oa_YYYY.tsv
$INPUTFILE_1799_WOS="$NPL_BASE" . "/nplmatch/inputs/wos/wosplpubinfo1955-2019_filteredISS.txt";
$INPUTFILE_1799_MAG="$NPL_BASE" . "/nplmatch/inputs/mag/magonelineFINAL.tsv"; # May need to change to magonelineFINAL.tsv
$INPUTFILE_1799_OA="$NPL_BASE" . "/nplmatch/inputs/openalex/openalexoneline.tsv";
$NPL_MISC="$NPL_BASE" . "/nplmatch/misc_files/";
$PERL_LEVDAM_PATH="#!/usr/local/bin/perl";



### directories that were commented out in the original config.pl file now found in the doNotDelete directory
#$INPUTDIR_PATENTS_FRONT="$NPL_BASE" . "/nplmatch/inputs/frontocrnpl/ocrnplbyrefyear/"; # Input files of format front_YYYY.tsv, 1947-1975 only, to account for google missing these
#$INPUTDIR_PATENTS_FRONT="$NPL_BASE" . "/rsp_prod/data/processed/front/front_by_refyear/"; # Input files of format front_YYYY.tsv
#$INPUTDIR_PATENTS_BODY="$NPL_BASE" . "/nplmatch/inputs/body/fulltext_2021j/bodybyrefyear/"; # Input files of format body_YYYY.tsv
#$INPUTDIR_PATENTS_BODY="$NPL_BASE" . "/nplmatch/inputs/body/fulltext_epo/bodybyrefyear/"; # Input files of format body_YYYY.tsv
#$INPUTDIR_PATENTS_BODY="$NPL_BASE" . "/nplmatch/inputs/body/bodybyrefyear/"; # Input files of format body_YYYY.tsv
#$INPUTDIR_JOURNAL_FRONT="$NPL_BASE" . "/rsp_prod/data/processed/journals/journalfrontbyrefyear/"; # Input files of format journalfront_YYYY.tsv
#$PERL_LEVDAM_PATH="!/share/pkg.7/perl/5.28.1/install/bin/perl";
