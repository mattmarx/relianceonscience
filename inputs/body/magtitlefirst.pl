while (<>) {
chomp;
 @line = split('\t', $_);
foreach my $val (@line) {
    #print ">$val<\n";
  }
 print "$line[7]\t$line[0]\t$line[1]\t$line[2]\t$line[3]\t$line[4]\t$line[5]\t$line[6]\t$line[7]\t$line[8]\n";
}
