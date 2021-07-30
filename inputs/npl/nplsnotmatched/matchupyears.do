set more off

forvalues year = 1800/2018 {
 di
 di
 di "converting year `year'"
 import delimited using nplsnotfoundbyyear/nplc_`year'.tsv, clear
 rename v1 patent
 rename v2 nplwithoutpatent
 rename v3 npltitle
 gen year = `year'
 save nplsnotfoundbyyear/nplc_`year', replace
 import delimited using nplsnotfoundbyyear/magtitles_`year'.tsv, clear
 rename v1 title
 rename v2 year
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
