args year
di "`year'"

import delimited using nplsnotfoundbyyear/nplc_`year'.tsv, clear
rename v1 patent
rename v2 nplwithoutpatent
rename v3 npltitle
gen year = `year'
// merge 1:1 papertitle using ../../../../mag/dta/magtitle.dta, keep(3)
// matchit n papertitle using ../../../../mag/dta/magtitle.dta, idusing(magid) txtusing(papertitle) override
joinby year using ../../../../mag/dta/papertitleyearnopat
matchit npltitle papertitle
keep if score>.9
keep patent nplwithoutpatent paperid
duplicates drop
save nplsnotfoundbyyear/nplsfound_`year.tsv, replace
