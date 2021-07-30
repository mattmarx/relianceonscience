import delimited using npltitlepieces/uniquenpltitles_`1'.tsv, clear
rename v1 npltitle
gen titlesoundex = soundex(npltitle)
joinby titlesoundex using uniquemagtitles
drop titlesoundex
matchit npltitle magtitle
keep if similscore>.75
// drop similscore
save npltitlepieces/uniquenpltitlematches_`1', replace
