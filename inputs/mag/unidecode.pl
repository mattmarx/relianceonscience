use utf8;
use Text::Unidecode;
while (<>) {
 chomp;
 $line = $_;
 $newline = unidecode($line);
 print "$newline\n";
}
