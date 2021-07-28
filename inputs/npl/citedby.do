import delimited using nplcitedbyOURS.tsv, clear
rename v1 patnum
rename v2 npl
gen examiner =  regexm(lower(npl), "examiner")
gen other  = regexm(lower(npl), "other")
gen applicant =  regexm(lower(npl), "applicant")
