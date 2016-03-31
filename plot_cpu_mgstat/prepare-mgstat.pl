#!/usr/bin/perl

#Prepare pButtons logs for gnuplot

$inputfile=$ARGV[0];

#################
# Hack stop wrap around when for greater than 24 hours ie runs into next day 23:59 -> 00:03
# Std pButtons 24 hours / 5 sec = 17240, set to all 99999 for max
$maxlinesOut=17240;

$mgstatfile=$inputfile.".mgstat.csv";

$dooutput=0;
$linecount=0;
$curfile="";

# Extract perfmon and mgstat data from pbuttons output into separate files
open INFILE, $inputfile;
while (<INFILE>) {
  $line=$_;

  if ($line=~m|beg_mgstat|) {
    open OUTFILE,">$mgstatfile";
    $curfile="mgstat";
    $dooutput=1;
    $linecount=0;
  } elsif ($line=~m|end_mgstat|) {
    close OUTFILE;
    $curfile="";
    $dooutput=0;
  } elsif ($dooutput) {
    next if !($line=~m|\S|); # Ignore the line if it's empty or only consists of whitespace
    $linecount++;
    if ($curfile ne "mgstat" || $linecount>1) {
      print OUTFILE $line;
    }
  }
}
close INFILE;


# Process mgstat files to remove unnecessary columns and make graphing easier

if ($curfile=="mgstat") {
	# Mgstat file
	@fieldlist=("Time","Glorefs","RemGrefs","PhyRds","Rdratio","Gloupds","RouLaS","PhyWrs","WDQsz","WDphase","Jrnwrts","BytSnt","BytRcd","WIJwri", "RouCMs", "Rourefs", "WDtmpq");
	$separator=",";
	&handleStatsFile($mgstatfile,\@fieldlist,$separator);
}


sub handleStatsFile {
  my $infile=$_[0];
  my @fieldlist=@{ $_[1] };

  my $outfile=$inputfile.".mgstat.clean.csv";
  my $headfile=$inputfile.".mgstat.header.txt";

  print $infile."\n";
  print $outfile."\n";

  my @fieldnumlist=();
  my @fieldheaders={};

  open INFILE,$infile;
  open OUTFILE,">$outfile";

  my $linecount=0;
  while (<INFILE>) {
     my $line=$_;
     $oline="";

     next if !($line=~m|\S|); # Ignore the line if it's empty or only consists of whitespace

     $linecount++;

     if ($linecount==1) {  # This is the header line. Get our field names
       chomp $line;
       $line=~s|[\n\r]||g;

       $fnum=0;
       foreach $fieldname (split /$separator/,$line) {
         $fieldname=~s|"||g;
         $fieldname=~s|^ *([^ ].*[^ ]) *$|\1|;
         $fieldname=~s|^\\\\[^\\]*\\||;

         # Handle perfmon column 1, date/time as the name varies by timezone
         $fieldname=~s|^.*(PDH\-CSV).*$|\1|;

         $fieldheaders{$fieldname}=$fnum;
         $fnum++;
       }

       # Compare headers to the list of fields to output
       foreach $fieldname (@fieldlist) {
         if (exists $fieldheaders{$fieldname}) {      
      $fnum=$fieldheaders{$fieldname};
      #print $fnum.":[".$fieldname."]\n";
      push @fieldnumlist,$fnum;
         }
       }
       
       #print join(":",@fieldnumlist) . "\n";

       # Dump all headers from original file into .header file for reference
       $line=~s|,|\n|g;
       open HEADFILE,">$headfile";
       print HEADFILE $line;
       close HEADFILE;
       $fnum=0;

       # Output header
       print OUTFILE join(",",@fieldlist)."\n";

     } else { # Output data line 
       @fields=split /$separator/,$line;
       foreach $fieldnum (@fieldnumlist) {
         $field=$fields[$fieldnum];
         $field=~s|\"||g;
         chomp $field;
         $field=~s|[\n\r]||g;
         $field=~s/(\d\d:\d\d:\d\d)\.\d\d\d/\1/;
         $field=~s|^(\d*\.\d\d\d)\d*$|\1|;
         $field=~s|(\d\d/\d\d/\d\d\d\d) (\d\d:\d\d:\d\d)|\2|;
         $field=~s|^ *$||;

         if ($field eq "") { $field=0 };

         $oline=$oline.$field.",";
       }
       ##### Hack limit line count
       if ($linecount<$maxlinesOut) { 
       		print OUTFILE $oline."\n";
       }
     }

  }
  close OUTFILE;
  close INFILE;
}
