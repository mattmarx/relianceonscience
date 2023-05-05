global wos "../../wos/dta/"
global pv "../../patents/patentsview"
global mag "../../mag/dta/"
global oecdfields "../../magoecdfields/"
global fung "../../patents/fung"
global googpat "../../patents/googpat"

import delimited using scored_body_wos_bestonlywgrobid.tsv, clear varnames(nonames)
rename v1 reftype
drop if length(reftype)>3
replace reftype = "app" if reftype!="exm"
compress reftype
rename v2 confscore
rename v3 wosid
rename v4 patent
drop v5
capture drop patnum
gen patnum = patent
* downweight cites where paper is far in the future
merge m:1 patnum using $googpat/1835-2019patgrantyears, keep(1 3) nogen
destring patnum, gen(patint) force
replace grantyear = 2019 if patint>10165721 & patint<10524402
replace grantyear = 2020 if patint>10524402 & !missing(patnum)
drop patint
merge m:1 wosid using $wos/wosyear, keep(1 3) nogen
replace confscore = confscore - 2 if year>grantyear+5 & !missing(grantyear) & !missing(year)
replace confscore = confscore - 3 if year>grantyear+10 & !missing(grantyear) & !missing(year)
// drop if confscore<3
replace confscore = 10 if confscore>10
replace patent = lower(trim(patent))
drop if missing(patent)
compress
replace patent = regexs(1) if regexm(lower(patent), "__us(.*)")
sort wosid patent confscore
drop if wosid==wosid[_n+1] & patent==patent[_n+1] & confscore<confscore[_n+1]
duplicates drop wosid patent, force
save scored_body_wos_bestonlyexport, replace
use scored_body_wos_bestonlyexport, clear
export delimited using scored_body_wos_bestonlyexport.tsv, replace delim(tab)
!cp scored_body_wos_bestonlyexport.tsv ~/sccpc/



