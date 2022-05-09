global wos "../../wos/dta/"
global pv "../../patents/patentsview"
global mag "../../mag/dta/"
global oecdfields "../../magoecdfields/"
global fung "../../patents/fung"
global googpat "../../patents/googpat"
global pubmed "../../pubmed/"

*!cut -f1,2,10,19 scoredbodypubmed_bestonly.tsv > scoredbodypubmed_bestonlyexport.tsv
import delimited using scored_body_pubmed_bestonlywgrobid.tsv, clear
rename v1 reftype
drop if length(reftype)>3
replace reftype = "app" if reftype!="exm"
compress reftype
rename v2 confscore
rename v3 pmid
rename v4 patent
replace confscore = 10 if confscore>10
replace patent = lower(trim(patent))
drop if missing(patent)
compress
sort pmid patent confscore
drop if pmid==pmid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop pmid patent, force
gen patnum = patent
merge m:1 patnum using ../../patents/googpat/1835-2019patgrantyears, keep(1 3) nogen
merge m:1 pmid using ../../pubmed/overall_dates_2019, keep(1 3) nogen keepusing(year)
replace confscore = confscore - 5 if year>grantyear+10 & !missing(grantyear) & !missing(year)
drop if confscore<3
drop patnum grantyear year
save scored_body_pubmed_bestonlyexport, replace
use scored_body_pubmed_bestonlyexport, clear
drop if pmid==pmid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop pmid patent, force

export delimited using scored_body_pubmed_bestonlyexport.tsv, replace delim(tab)
!cp scored_body_pubmed_bestonlyexport.tsv ~/sccpc/


