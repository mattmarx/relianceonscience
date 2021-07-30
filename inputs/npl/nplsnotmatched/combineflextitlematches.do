global magsetup 0

if ($magsetup==1) {
 use magid papertitle using nplsnotfoundbyyear/magtitleyear, clear
 drop  if length(papertitle)>500
 recast str500 papertitle
 save magtitle500max, replace
 import delimited using ../../mag/mergedmagfornpl-fixednames.tsv, clear
 rename v1 year
 rename v2 magid
 rename v3 volume
 rename v4 issue
 rename v5 firstpage
 rename v6 lastpage
 rename v7 authorname
 * don't have to smush down title this time, elave as strL
 rename v8 papertitle
 rename v9 journalname
 save ../../mag/mergedmagfornpl-fixednames, replace
}

set more off
clear all
* load all of the pieces matches and combine them
forvalues i = 10000/11737 {
 di "adding year `i'"
 capture append using npltitlepieces/uniquenpltitlematches_`i'
}
* something is messed up but whatevs
// capture replace papertitle = magtitle if missing(papertitle)
// capture drop magtitle
save uniquenpltitlematches75plus, replace
keep if similscore>.9
save uniquenpltitlematches90plus, replace

use uniquenpltitlematches75plus, clear
// use uniquenpltitlematches90plus, clear
* get the patent & npl
joinby npltitle using nplsnotmatchedwtitles
* get the magid
rename magtitle papertitle
drop if length(papertitle)>500
recast str500 papertitle
compress
joinby papertitle using magtitle500max
* now use the magid to get all of the paper data. oddly, drop the title and re-merge it
drop papertitle 
tostring magid, replace
merge m:1 magid using ../../mag/mergedmagfornpl-fixednames, keep(1 3) nogen
save notfoundnplsbytitlematches, replace
export delimited magid year volume issue firstpage lastpage authorname papertitle journalname patent nplwithoutpatent using notfoundnplsbytitlematches.tsv, delim(tab) replace novarnames

 
