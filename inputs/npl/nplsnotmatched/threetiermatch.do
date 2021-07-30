set more off
global convertsvdta 0 

* convert tsv of unmatched to dtas
if ($convertsvdta==1) {
 forvalues year = 1800/2018 {
  di
  di
  di "converting year `year'"
  import delimited using nplsnotfoundbyyear/nplc_`year'.tsv, clear
  rename v1 npltitle
  gen titlesoundex = soundex(npltitle)
//   recast str2000 title
//   compress title
  rename v2 patent
  rename v3 nplwithoutpatent
  //gen year = `year'
  save nplsnotfoundbyyear/nplc_`year', replace
 }

// forvalues year = 1800/2018 {
//  di "fixing `year'"
//  use nplsnotfoundbyyear/nplc_`year', clear
//  rename title npltitle
//  save, replace
// }
}
* for each year, read in and then merge. write out direct matches (if either)0000000000000000000000000000000000000000000000000000000000000000000000000
* then joinby on soundex and matchit on the matches
forvalues year = 1800/2018 {
 di "matching year `year'"
//  import delimited using nplsnotfoundbyyear/magtitles_`year'.tsv, clear
//  rename v1 title
//  rename v2 year
 use magid year papertitle if year==`year' using nplsnotfoundbyyear/magtitleyear, clear
 drop year
 compress	
//  recast str2000 title
//  compress npltitle
//  preserve
//  {
//   joinby npltitle using nplsnotfoundbyyear/nplc_`year'
//   capture save nplsnotfoundbyyear/nplcexactitlematch_`year', replace
//  }
//  restore
 gen titlesoundex = soundex(papertitle)
 joinby titlesoundex using nplsnotfoundbyyear/nplc_`year'
 matchit npltitle papertitle
 keep if similscore>.9
 save nplsnotfoundbyyear/nplsfound_`year'.tsv, replace
} 
/* 
save nplsnotfoundbyyear/magtitles_`year', replace


// merge 1:1 papertitle using ../../../../mag/dta/magtitle.dta, keep(3)
// matchit n papertitle using ../../../../mag/dta/magtitle.dta, idusing(magid) txtusing(papertitle) override
}

forvalues year = 1800/2018 {
 di
 di
 di "doing year `year'"
 use nplsnotfoundbyyear/nplc_`year', clear
 compress
 joinby year using nplsnotfoundbyyear/magtitles_`year'
 matchit title npltitle, threshold(.9)
 keep if similscore>.9
 keep patent nplwithoutpatent title
 capture duplicates drop
 capture save nplsnotfoundbyyear/nplsfound_`year'.tsv, replace
}
