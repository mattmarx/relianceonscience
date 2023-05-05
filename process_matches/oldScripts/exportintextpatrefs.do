global googpat "../../patents/googpat"

use $googpat/intlpatappyear, clear
replace patnum = regexs(1) if regexm(patnum, "(.*)-.*")
duplicates drop patnum, force
save $googpat/intlpatappyearnosuffix, replace

import delimited using ../grobid/intext_refs_to_patents.tsv, clear delim(tab)
rename v1 citingpatent
gen citingpatentus = regexm(citingpatent, "US")
rename v2 citedpatent
gen citedpatentus = regexm(citedpatent, "US")
duplicates drop
drop if !regexm(citingpatent, "[0-9]")
drop if !regexm(citedpatent, "[0-9]")
gen zzzpatent = citingpatent
do ../replication/assignusptograntyears
rename zzzyear citingpatentyear
replace citingpatentyear = . if citingpatentus==0
drop zzz*
gen patnum = citingpatent
merge m:1 patnum using $googpat/intlpatappyearnosuffix, keep(1 3) nogen
replace citingpatentyear = appyear if missing(citingpatentyear) & !missing(appyear) & citedpatentus==0
drop appyear patnum
drop if missing(citingpatentyear)

gen zzzpatent = citedpatent
do ../replication/assignusptograntyears
rename zzzyear citedpatentyear
replace citedpatentyear = . if citedpatentus==0
drop zzz*
gen patnum = citedpatent
merge m:1 patnum using $googpat/intlpatappyearnosuffix, keep(1 3) nogen
replace citedpatentyear = appyear if missing(citedpatentyear) & !missing(appyear) & citedpatentus==0
drop appyear patnum
drop if missing(citedpatentyear)

gen lag = citingpatentyear - citedpatentyear 

drop if lag <-15
drop citingpatentus citedpatentus lag
compress
duplicates drop
save intextpatrefstopatents, replace
export delimited using intextpatrefstopatents.tsv, delim(tab) replace
!cp intextpatrefstopatents.tsv ~/sccpc/transfer
