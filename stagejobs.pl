#!/usr/local/bin/perl

$jobname=$ARGV[0];

if (!$jobname) { die "Usage: stagejobs.pl JOBNAME\n"; }

$loginname=`whoami`;
$loginname=~s/\s+//g;

# Begin at step 1, monitoring for $jobname to start.
$step=1;
while(1==1) {
    $qstat_result=`qstat -u $loginname`;

    # Check if job we are monitoring has started.  If so, move to step2.
    if ($qstat_result=~/$jobname/) { 
	if ($step==1) {
	    $date=`date`;
	    $date=~s/^\s+//;
	    $date=~s/\s+$//;
	    print "Stagejobs.pl - Moving to Step2 (job has started running) for $jobname at $date\n";
	}
	$step=2; 
    }
    # If in Step2, $jobname has ended, and qstat is returning reasonable results ('S1T' for example) exit script to allow next stage to begin.
    elsif (($step==2)&&(!($qstat_result=~/$jobname/))&&($qstat_result=~/S[123][TCJ]/)) {
	$date=`date`;
	$date=~s/^\s+//;
	$date=~s/\s+$//;
	print "Stagejobs.pl - Ending.  $jobname completed at $date\n";
	exit 0;
    }

    # Sleep for 5 minutes and then do another check.
    sleep(300);
}
