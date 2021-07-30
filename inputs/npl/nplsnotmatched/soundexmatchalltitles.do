import delimited using uniquenpltitles.tsv, clear
rename v1 npltitle
drop if length(npltitle)<10
gen titlesoundex = soundex(npltitle)
drop if missing(titlesoundex)
compress
save uniquenpltitles, replace


import delimited using uniquemagtitles.tsv, clear
rename v1 magtitle
drop if length(magtitle)<10
gen titlesoundex = soundex(magtitle)
drop if missing(titlesoundex)
compress
save uniquemagtitles, replace

use uniquemagtitles, clear
joinby titlesoundex using uniquenpltitles
save joinedtitlesoundex, replace
matchit npltitle magtitle
keep if similscore>.9
save similartitles, replace

