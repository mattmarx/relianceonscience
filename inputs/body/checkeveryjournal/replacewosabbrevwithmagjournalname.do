

*import delimited using matchedjournals.tsv, delim(tab) clear
*rename v1 wosjournalabbrev
*rename v2 patnum
*rename v3 npl
*replace wosjournalabbrev = trim(wosjournalabbrev)
*save matchedjournals, replace
use matchedjournals, clear
joinby wosjournalabbrev using ../../../../xwalkwosmag/wosmagjournalxwalk

keep journalname patnum npl
compress
duplicates drop
save matchedjournalsmagname, replace
use matchedjournalsmagname, clear
export delimited using matchedjournalsmagname.tsv, delim(tab) replace
