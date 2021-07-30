* splittitleyear
global fromscratch 0

if ($fromscratch==1) {
use ../../../../mag/dta/magyear, clear
rename magid paperid
merge 1:1 paperid using ../../../recall/magpatents, keep(1) nogen
rename paperid magid
merge 1:1 magid using ../../../../mag/dta/magtitle, keep(3) nogen
// use ../../../../mag/dta/magtitle, clear
// merge 1:1 magid using magyear, keep(3)
// keep year papertitle
drop if !regexm(papertitle, "[a-z]")
drop if length(papertitle)<10
save nplsnotfoundbyyear/magtitleyear, replace
}

forvalues year = 1800/2018 {
//  import delimited using nplsnotfoundbyyear/magtitles_`year'.tsv, clear
//  rename v1 title
//  rename v2 year
 use magid year papertitle if year==`year' using nplsnotfoundbyyear/magtitleyear, clear
 drop year
 compress
 save nplsnotfoundbyyear/magtitleyear`year', replace
} 
/*
forvalues i = 1800/2018 {
 di "saving `i'"
 preserve 
 {
  keep if year==`i'
  save nplsnotfoundbyyear/magtitleyear`i', replace
 }
 restore
}


