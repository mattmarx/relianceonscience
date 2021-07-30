args segment
di "`segment'"

import delimited using npls2check_1`segment'.tsv, clear
rename v1 patent
rename v2 nplwithoutpatent
rename v3 papertitle
gen n = _n
// merge 1:1 papertitle using ../../../../mag/dta/magtitle.dta, keep(3)
matchit n papertitle using ../../../../mag/dta/magtitle.dta, idusing(magid) txtusing(papertitle) override

