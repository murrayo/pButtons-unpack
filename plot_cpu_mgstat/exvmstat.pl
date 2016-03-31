#!/usr/bin/perl 

$infile=$ARGV[0];

$vmstatfile=$infile.".vmstat.csv";

$foundVmstat=0;
$printIt=0;


# Extract vmstat
open INFILE, $infile;
while (<INFILE>) {
  $line=$_;
    
  if ($line=~m|beg_vmstat|) {
    open OUTFILE,">$vmstatfile";
    $curfile="vmstat";
    $dooutput=1;
    $linecount=0;
  } elsif ($line=~m|end_vmstat|) {
    close OUTFILE;
    $curfile="";
    $dooutput=0;
  } elsif ($dooutput) {
    next if !($line=~m|\S|); # Ignore the line if it's empty or only consists of whitespace
    $linecount++;
    
    $line=~s/^ +//;
    $line=~s/ +/,/g;  # Add comma delimit
    print OUTFILE $line;
    }
}
close INFILE;


# AIX lanakshire
#</pre><p align="right"><font size="3"><a href="#Topofpage">Back to top</a></font></p><hr size="4" noshade><b><font face="Arial, Helvetica, sans-serif" size="4" color="#0000FF"><div id=vmstat></div>vmstat</font></b><br><!-- beg_vmstat --><pre>  r  b   avm   fre  re  pi  po  fr   sr  cy  in   sy  cs us sy id wa hr mi se
#   1  1 7738408 10669   0   0   0  19   19   0 571 88893 1817 13  1 84  2 00:01:11
#   1  1 7738063 10028   0   0   0  26  126   0 723 5031 1926 10  0 88  2 00:01:16
# <!-- end_vmstat -->