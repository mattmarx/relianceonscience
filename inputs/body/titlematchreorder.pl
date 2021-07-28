while (<>) {
chomp;
 @line = split('\t', $_);
 $line[11] = lc $line[11];
 print "$line[2]\t$line[1]\t$line[3]\t$line[4]\t$line[5]\t$line[6]\t$line[7]\t$line[8]\t$line[9]\t$line[10]\t$line[11]\n";
}
