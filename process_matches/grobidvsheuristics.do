//cut -f2,10,19 scored_body_mag_sorted.tsv > scored_body_mag_sorted
use confscore magid patent patentline using scored_body_mag, clear

gen grobid = regexm(patentline, "__zqxgrobidzqx__")
drop patentline
sort magid patent grobid confscore
drop if magid==magid[_n-1] & patent==patent[_n-1] & grobid==grobid[_n-1] & confscore<=confscore

bys  magid patent: egen pctgrobid = mean(grobid)
gen onlygrobid = pctgrobid==1
gen onlyheuristic = pctgrobid==0
gen tempconfscoregrobid = confscore if grobid==1
gen tempconfscoreheuristic = confscore if grobid==0

bys magid patent: egen confscoregrobid = max(tempconfscoregrobid)
bys magid patent: egen confscoreheuristic = max(tempconfscoreheuristic)

gen grobidhigher = confscoregrobid > confscoreheuristic & onlygrobid==0 & onlyheuristic==0

drop temp* confscoregrobid confscoreheuristic grobid
sort magid patent confscore pctgrobid
drop if magid==magid[_n-1] & patent==patent[_n-1] & confscore<=confscore
duplicates drop
gen matchtype = "both"
replace matchtype = "onlygrobid" if onlygrobid==1
replace matchtype = "onlyheuristic" if onlyheuristic==1
drop onlygrobid onlyheuristic
replace confscore = 10 if confscore>10

