#!/usr/bin/perl

#Prepare pButtons logs for gnuplot
# Initial, Marc Mundt
#20120826, Murray Oldfield, murray.oldfield@intersystems.com, Initial Release, 
#20120831, Casep, casep@intersys.com, CPU for Unix
#20120905, MO, change from tab to comma separate, add some more columns

$inputfile=$ARGV[0];

#################
# Hack stop wrap around when for greater than 24 hours ie runs into next day 23:59 -> 00:03
# Std pButtons 24 hours / 5 sec = 17240, set to all 99999 for max
$maxlinesOut=17240;

$perfmonfile=$inputfile.".perfmon.csv";

$dooutput=0;
$linecount=0;
$curfile="";

print "Starting perfmon extract\n\n";
print "IN  :".$inputfile."\n\n";

# Extract perfmon and mgstat data from pbuttons output into separate files
open INFILE, $inputfile;
while (<INFILE>) {
  $line=$_;

# Look for match in each line for start of perfmon, output all perfmon lines

  if ($line=~m|beg_win_perfmon|) {
    open OUTFILE,">$perfmonfile";
    $curfile="perfmon";
    $dooutput=1;
    $linecount=0;
  } elsif ($line=~m|end_win_perfmon|) {
    close OUTFILE;
    $curfile="";
    $dooutput=0;
  } elsif ($dooutput) {
    next if !($line=~m|\S|); # Ignore the line if it's empty or only consists of whitespace
    $linecount++;
      print OUTFILE $line;
  }
}
close INFILE;


# Process perfmon file to remove unnecessary columns and make graphing easier

# Perfmon file
# Note: Column names in fieldlist should have the server name removed from the beginning and backslash needs to be escaped
#       For Perfmon, the first date/time column should be named "PDH-CSV" in this list, even though the actual column name is different.

#my @fieldlist=("PDH-CSV","Processor(_Total)\\% Privileged Time","Processor(_Total)\\% User #Time","Processor(_Total)\\% Processor #Time","Processor(_Total)\\Interrupts/sec","\Memory\\Available MBytes","\Memory\\Page #Reads/sec","\Memory\\Page Writes/sec","\Paging File(_Total)\\% #Usage","\PhysicalDisk(_Total)\\Disk Transfers/sec","\System\\Processes","System\\Processor #Queue Length");

################ YOU WILL NEED TO ADJUST THE DISK SECTION
## Use txt.header

## \\RSPIPON-TRAK01 - database server

my @fieldlist=("Time",
	"Processor(_Total)\\% User Time",
	"Processor(_Total)\\% Processor Time",
	"Processor(_Total)\\Interrupts/sec",
	"Memory\\Available MBytes",
	"Memory\\Page Reads/sec",
	"Memory\\Page Writes/sec",
	"Paging File(_Total)\\% Usage",
	"PhysicalDisk(_Total)\\Disk Transfers/sec",
	"System\\Processes",
	"System\\Processor Queue Length",
	"Processor(_Total)\\% Privileged Time",
	
	"PhysicalDisk(1 E:)\\Avg. Disk sec/Read",
	"PhysicalDisk(1 E:)\\Avg. Disk sec/Write",
	"PhysicalDisk(1 E:)\\Disk Transfers/sec",
	
	"PhysicalDisk(2 J:)\\Avg. Disk sec/Read",
	"PhysicalDisk(2 J:)\\Avg. Disk sec/Write",
	"PhysicalDisk(2 J:)\\Disk Transfers/sec",
	
	"PhysicalDisk(0 C:)\\Avg. Disk sec/Read",
	"PhysicalDisk(0 C:)\\Avg. Disk sec/Write",
	"PhysicalDisk(0 C:)\\Disk Transfers/sec",
	
	"Network Interface(Intel[R] PRO_1000 MT Network Connection)\\Bytes Received/sec",
	"Network Interface(Intel[R] PRO_1000 MT Network Connection)\\Bytes Sent/sec",

	"PhysicalDisk(1 E:)\\Disk Read Bytes/sec",
	"PhysicalDisk(1 E:)\\Disk Reads/sec",
	"PhysicalDisk(1 E:)\\Disk Write Bytes/sec",
	"PhysicalDisk(1 E:)\\Disk Writes/sec",

	"PhysicalDisk(2 J:)\\Disk Read Bytes/sec",
	"PhysicalDisk(2 J:)\\Disk Reads/sec",
	"PhysicalDisk(2 J:)\\Disk Write Bytes/sec",
	"PhysicalDisk(2 J:)\\Disk Writes/sec",

	"PhysicalDisk(0 C:)\\Disk Read Bytes/sec",
	"PhysicalDisk(0 C:)\\Disk Reads/sec",
	"PhysicalDisk(0 C:)\\Disk Write Bytes/sec",
	"PhysicalDisk(0 C:)\\Disk Writes/sec",
	
	"PhysicalDisk(_Total)\\Disk Write Bytes/sec",
	"PhysicalDisk(_Total)\\Disk Writes/sec",
	
	"Network Interface(vmxnet3 Ethernet Adapter)\\Bytes Received/sec",
	"Network Interface(isatap.{B13B21CE-4C21-4B7F-96D7-3B6DF2E989DF})\\Bytes Received/sec",
	"Network Interface(isatap.{E4B4B8BB-F979-4532-BA66-4C0B4AEC9F72})\\Bytes Received/sec",
	"Network Interface(Local Area Connection* 9)\\Bytes Received/sec",

	"Network Interface(vmxnet3 Ethernet Adapter)\\Bytes Sent/sec",
	"Network Interface(isatap.{B13B21CE-4C21-4B7F-96D7-3B6DF2E989DF})\\Bytes Sent/sec",
	"Network Interface(isatap.{E4B4B8BB-F979-4532-BA66-4C0B4AEC9F72})\\Bytes Sent/sec",
	"Network Interface(Local Area Connection* 9)\\Bytes Sent/sec"
	);
	
	$separator=",";
	&handleStatsFile($perfmonfile,\@fieldlist,$separator);


sub handleStatsFile {
  my $infile=$_[0];
  my @fieldlist=@{ $_[1] };

  print "Extracting columns\n\n";
  my $outfile=$inputfile.".perfmon.clean.csv";
  my $headfile=$inputfile.".perfmon.header.txt";

  print "IN  :".$infile."\n";
  print "OUT :".$outfile."\n\n";
  
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
 
		   chomp $line; # remove newline
		   $line=~s|[\n\r]||g; # remove newline carriage return

		   $fnum=0;
		   foreach $fieldname (split /$separator/,$line) { # Remove quotes from input file
				 $fieldname=~s|"||g;
				 $fieldname=~s|^ *([^ ].*[^ ]) *$|\1|;
				 $fieldname=~s|^\\\\[^\\]*\\||; # Remove double leading quotes and machine name

				 $fieldname=~s|^\\||; # Remove leading quotes when no machine name (e.g. custom extract)

				 # Handle perfmon column 1, date/time as the name varies by timezone
				 $fieldname=~s|^.*(PDH\-CSV).*$|\1|;
		 
				 # Assign field number to each heading 
				 $fieldheaders{$fieldname}=$fnum;
				 $fnum++;
			   
				 # print "$fieldheaders $fieldname \n";				  
		   }

		   # Compare headers to the list of fields to output
	   
		   foreach $fieldname (@fieldlist) {
		 
			 if (exists $fieldheaders{$fieldname}) {      
				  $fnum=$fieldheaders{$fieldname};
			  
				  # print $fnum.":[".$fieldname."]\n";
			  
				  push @fieldnumlist,$fnum; # Append to end of array
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

			  # Strip out date from date time
			  # "02/05/2014 00:01:06.177"
			  	
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
