

use scored_body_mag_bestonlyexport, clear
gen zzzpatent = patent
do ../replication/assignusptograntyears
keep if zzzyear<1937
rename zzzyear patentyear
drop zzz*
merge 1:m magid patent using ../process_matches/scored_body_mag, keep(1 3) nogen
duplicates drop magid patent, force
drop year
merge m:1 magid using ../../../bigdata/mag/dta/magyear, keep(1 3) nogen
rename year paperyear
drop if missing(patentline)
save refs1800s, replace
export excel using refs1800s, firstrow(variables) replace
