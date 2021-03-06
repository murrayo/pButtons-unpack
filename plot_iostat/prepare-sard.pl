#!/usr/bin/perl

#Prepare pButtons logs for gnuplot - sar -d Red Hat 6.3

# ./prepare-sard.pl ./data/UFHTRAK2013A_H2012TC_20130508_0001_23hours55.html dev66-16
# ./do_graph_sard.sh data ./data/UFHTRAK2013A_H2012TC_20130508_0001_23hours55.htmlsard_dev66-16_.txt.clean.csv


$infile=$ARGV[0];
$disk=$ARGV[1];
$isFirst=$ARGV[2];
$startTime=$ARGV[3];

#################
$sardfile=$infile."_".$isFirst.".txt";

$dooutput=0;
$linecount=0;
$curfile="";

unless (-e $sardfile) {
	# Extract sard data from pbuttons output into separate files
	open INFILE, $infile;
	while (<INFILE>) {
	  $line=$_;

	  if ($line=~m|id=sar-d|) {
		open OUTFILE,">$sardfile";
		$curfile="sard";
		$dooutput=1;
		$linecount=0;
	  } elsif ($line=~m|Average:|) {
		close OUTFILE;
		$curfile="";
		$dooutput=0;
	  } elsif ($dooutput) {
		next if !($line=~m|\S|); # Ignore the line if it's empty or only consists of whitespace
		$linecount++;
		if ($curfile ne "sard" || $linecount>1) {
		  print OUTFILE $line;
		}
	  }
	}
	close INFILE;
}

if ($curfile=="sard") {
	# sard file
	@fieldlist=("$startTime","DEV","tps","rd_sec/s","wr_sec/s","avgrq-sz","avgqu-sz","await","svctm","%util");
	$separator=" +";
	&handleStatsFile($sardfile,\@fieldlist,$separator);
}


sub handleStatsFile {
  my $infile=$_[0];
  my @fieldlist=@{ $_[1] };

#  my $outfile=$infile.".clean.csv";
  my $outfile=$infile."_".$isFirst."_".$disk.".csv";

  my $headfile=$infile.".header.txt";

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
       
       # Only output for selected disk
       
       if ($fields[1] eq "$disk") {

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

    		print OUTFILE $oline."\n";
       	}
     }

  }
  close OUTFILE;
  close INFILE;
}
