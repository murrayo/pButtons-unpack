#!/usr/bin/perl 

# prepare-iostatAIX.pl


$infile=$ARGV[0];
$disk=$ARGV[1];
$isFirst=$ARGV[2];


$iostatfile=$infile."_".$isFirst.".txt";

$dooutput=0;
$linecount=0;
$curfile="";

# Extract iostat data from pbuttons output into separate file if first time in

unless (-e $iostatfile) {
 
	open INFILE, $infile;
	while (<INFILE>) {
	  $line=$_;

	  if ($line=~m|id=iostat|) {
		open OUTFILE,">$iostatfile";
		$curfile="iostat";
		$dooutput=1;
		$linecount=0;
	  } elsif ($line=~m|#Topofpage|) {
		close OUTFILE;
		$curfile="";
		$dooutput=0;
	  } elsif ($dooutput) {
		next if !($line=~m|\S|); # Ignore the line if it's empty or only consists of whitespace
		$linecount++;
		if ($curfile ne "iostat" || $linecount>1) {
		  print OUTFILE $line;
		}
	  }
	}
	close INFILE;
}

$separator=" +";
&handleStatsFile($iostatfile,$separator);

# Create output

sub handleStatsFile {
  my $infile=$_[0];

  my $outfile=$infile."_".$isFirst."_".$disk.".csv";

  print $infile."\n";
  print $outfile."\n";

  open INFILE,$infile;
  open OUTFILE,">$outfile";

	
#	Disks:                     xfers                                read                                write                                  queue                    time
#                 %tm    bps   tps  bread  bwrtn   rps    avg    min    max time fail   wps    avg    min    max time fail    avg    min    max   avg   avg  serv
#                 act                                    serv   serv   serv outs              serv   serv   serv outs        time   time   time  wqsz  sqsz qfull
# Attach header
$headerText="Disk,x_%tm,x_bps,x_tps,x_bread,x_bwrtn,r_rps,r_avg_sv,r_min_sv,r_max_sv,r_time_out,r_fail,w_wps,w_avg_sv,w_min_sv,w_max_sv,w_time_out,w_fail,q_avg_tim,q_min_time,q_max_time,q_avg_wqsz,q_avg_sqsz,q_serv_qfull,time"."\n";
print OUTFILE $headerText;

  my $linecount=0;
  while (<INFILE>) {
     my $line=$_;
     $oline="";

     next if !($line=~m|\S|); # Ignore the line if it's empty or only consists of whitespace
     $linecount++;

	# Output data line (add comma separator)
	@fields=split /$separator/,$line;
       
    # Only output for selected disk
     
    if ($fields[0] eq "$disk") {
       print OUTFILE join(",",@fields);
	}
	
  }
  close OUTFILE;
  close INFILE;
}

