#!/local/bin/perl

while (<>) {
 $hasyear = 0;
 for ($year=1800; $year<2019; $year++) {
  $hasyear = 1 if /\D$year\D/;
 }
 print if $hasyear==0;
}
