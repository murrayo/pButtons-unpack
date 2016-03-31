#!/bin/sh
# Usage: ./peakavg_P.sh -a -d ../ZCust/201503_Not_Trak/034_Roche/20150726/Customer_Info/Zamora 
# Beware spaces in file path
# 

# 3 Sigma Peak Peak is where top ~1% are dropped as outliers
# Set for 99.7% (3 sigma)
CutOff=".997"
# Set for 09: start (mgstat - measured during Peak activity)
TimeStart="09:"
# Set for 10:59 Stop 
TimeEnd="11:"


Usage="Usage: $0 [-a] -d directory ... \n\tselect -d directory_to_work_on -[a]ll times"

while getopts d:vmax o
do	case "$o" in
	d)  InputFolder="$OPTARG" ;;
	a)  allTimes="Y";;
	[?])	echo 
	exit 1;;
	esac
done

# Basic validation

if [ -z $InputFolder ];
then
	echo $Usage
	exit 1
fi
	
if [ ! -d $InputFolder ];
then
	echo $InputFolder is not a known directory
	echo $Usage
	exit 1
fi

# Where are we now folder
CurrentFolder=`pwd`
cd $InputFolder

myname=`basename "${InputFolder}"`
echo $myname


# Std format of perfmon extraction to 'clean.csv'

# ./gnu_graph.sh $1 2 "User Time" 1 1 0
# ./gnu_graph.sh $1 3 "Total Processor Time" 1 1 0
# ./gnu_graph.sh $1 4 "Interrupts" 0 1 0
# ./gnu_graph.sh $1 5 "Available MBytes" 0 1 0
# ./gnu_graph.sh $1 6 "Memory Page Reads per sec" 0 1 0
# ./gnu_graph.sh $1 7 "Memory Page Writes per sec" 0 1 0
# ./gnu_graph.sh $1 8 "Memory Paging File Total Pct usage" 1 1 0
# ./gnu_graph.sh $1 9 "Total Disk Transfers" 0 1 0 
# ./gnu_graph.sh $1 10 "Processes" 0 1 0
# ./gnu_graph.sh $1 11 "Processor Queue" 0 1 0
# ./gnu_graph.sh $1 12 "Privileged Time" 1 1 0

# ./gnu_graph.sh $1 13 "R data Avg Disk sec Read" 0 1 1
# ./gnu_graph.sh $1 14 "R data Avg Disk sec Write" 0 1 1
# ./gnu_graph.sh $1 15 "R data Disk Transfers sec" 0 1 0
# ./gnu_graph.sh $1 16 "S jnl Avg Disk sec Read" 0 1 1
# ./gnu_graph.sh $1 17 "S jnl Avg Disk sec Write" 0 1 1
# ./gnu_graph.sh $1 18 "S jnl Disk Transfers sec" 0 1 0

# Output
outfile="../3_Sigma_PeakPeak_perfmon.csv"

if [ ! -f $outfile ]
then
	printf "Site,File name,3 Sigma Peak Processor Queue,3 Sigma Peak User Time,3 Sigma Peak Privileged Time,3 Sigma Peak Total Processor Time,3 Sigma Peak Processes,3 Sigma Peak Total Disk Transfers,3 Sigma Peak data Avg Disk sec Read,3 Sigma Peak data Avg Disk sec Write,3 Sigma Peak data Disk Transfers sec" > $outfile
	printf ",ABS PEAK-->,Processor Queue,User Time,Privileged Time,Total Processor Time,Processes,Total Disk Transfers,data Avg Disk sec Read,data Avg Disk sec Write,data Disk Transfers sec" >> $outfile
	printf ",AVERAGE-->,Processor Queue,User Time,Privileged Time,Total Processor Time,Processes,Total Disk Transfers,data Avg Disk sec Read,data Avg Disk sec Write,data Disk Transfers sec" >> $outfile
	printf "\r\n" >>$outfile
else
	echo "Appending to end of existing $outfile"
fi

for infile in `ls *.perfmon.clean.csv`
do 
	
	# Print original file name
	echo "--------------------------------------"
	echo "$infile"
	printf "${myname},${infile}" >>$outfile
	
	cpuName="$infile"_cpu.csv


	if [ ! -z $allTimes ];
	then					
		printf " - All Times" >>$outfile					
		cp $infile temp.txt
	else		
		# Select only Peak hours 09:00-10:59
		printf " - ${TimeStart} to ${TimeEnd}" >>$outfile	
		sed -n -e '/^'${TimeStart}'/,/^'${TimeEnd}'/p' $infile >temp.txt
	fi
	infile="temp.txt"
	
				
	# How many lines in perfmon now
	totalLines=1
	totalLines=`wc -l < ${infile}`
	
	# Remove last line (11:00:nn)
	head -n $((totalLines-1)) temp.txt > temp1.txt; mv temp1.txt temp.txt
	totalLines=`wc -l < ${infile}`
	echo "perfmon total lines: " $totalLines 

	
	# Where is the 3 sigma cut off? Need to get maximum from top and bottom
	SigmaCnt=1
	SigmaCnt=`printf "%.0f" $(echo "scale=2;($totalLines-($totalLines*${CutOff}))" | bc)`
	echo "perfmon take off n: " $SigmaCnt
	
	# How many without 3 sigma
	Remainder=$(($totalLines-$SigmaCnt))
	echo "Remainder lines : " $Remainder
	
	# How many off top and bottom
	takeOff=$((SigmaCnt/2))
	echo "Take off top and take off bottom: " $takeOff
	

	#--- Sort and print 3 Sigma Peak Peak
	for fieldNo in 11 2 12 3 10 9 13 14 15
	do 
		# Create temp file containing only data between Sigma
		printf "," >>$outfile
		printf "`sort -g -r -t, -k${fieldNo} ${infile} | head -$(($totalLines-$takeOff)) | tail -$(((totalLines-$takeOff)-$takeOff)) | head -1 | cut -f${fieldNo} -d,`" >>$outfile
	done

	printf "," >>$outfile
	#--- Sort and print true Peak
	for fieldNo in 11 2 12 3 10 9 13 14 15
	do 
		printf "," >>$outfile
		printf "`sort -g -r -t, -k${fieldNo} ${infile} | head -1 | cut -f${fieldNo} -d,`" >>$outfile
	done

	printf "," >>$outfile
	# Now for Average - need to loose top and bottom for 3 sigma again
	for fieldNo in 11 2 12 3 10 9 13 14 15
	do 
		printf "," >>$outfile
		printf "`sort -g -r -t, -k${fieldNo} ${infile} | head -$(($totalLines-$takeOff)) | tail -$(((totalLines-$takeOff)-$takeOff))`" >ztempa.csv
		awk -F ',' '{ total += $'$fieldNo'; count++ } END { printf "%d", total/count }' ztempa.csv >>$outfile
	done

	printf "\r\n" >>$outfile
	
done	

echo $outfile " ready"

rm temp.txt
rm ztempa.csv

cd "$CurrentFolder"

	
		









