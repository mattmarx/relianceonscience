use remaining_pat
gen nous = checkpat
replace nous = "USpat" if regexm(nous, "^US[1-9]*")
drop if nous == "USpat"
save remaining_pat, replace
 export delimited using remaining_pat.tsv, replace delim(tab)
