#!/bin/sh

# This script loops through multiple subdirectories to create graphs
# Useful for benchmarks especially but also where customer data has multiple servers, also with the option of sorting and displaying top 10 websys.Monitor components based on response time

# Usage:    ./ddescend.sh -g -d ../ZCust/bench_IBM201502_Cambridge/collected_RH/0413
#			./ddescend.sh -g -d ../ZCust/UfhEPS/ufh_perf_2015_05/ufh.pbuttons.2015-05-18
# 			./ddescend.sh -g -d ../ZCust/041_Lothian/2015_04/pButtonsOnlyAll
# 			./ddescend.sh -g -w -d ../ZCust/bench_Intel_2015/0611	

# Beware spaces in file path


# 1. Build graphs
# 2. Build csv of peaks and averages
# 3. Find average of top 10 average response times in websys.Monitor

Usage="Usage: $0 [-g] [-a] [-s] [-w] -d directory ... \n\tselect one or more of -d directory_to_work_on -[g]raphs -[a]ix -[s]napshots -[w]ebsys.Monitor"

while getopts d:gasw o
do	case "$o" in
	d)  InputFolder="$OPTARG" ;;
	g)	graphs="Y";;
	a)  aix="Y";;
	s)  snapshot="Y";;	
	w)	websys="Y";;
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


# Change to input directory and get sub directory names

cd "${InputFolder}"
Filelist=`find . -maxdepth 1 -type d -name [^\.]\* | sed 's:^\./::'`

cd "${CurrentFolder}"

foldername=`basename ${InputFolder}`
outfile="${InputFolder}/${foldername}_runstats.csv"
csvoutfile="${InputFolder}/${foldername}_csvtop10.csv"

Looped="N"

for j in ${Filelist}
do

	echo $j
	

	if [ ! -z $graphs ];
	then

		# 1. Build graphs - aix or default is red hat, default no snap shots
		
			if [ ! -z $aix ];
			then

				if [ -z $snapshot ];
				then
					./dgsh -m -a6 -d "${InputFolder}/$j" 2>/dev/null 
					
				else	
					./dgsh -m -s -a6 -d "${InputFolder}/$j" 2>/dev/null 
				fi
					
				# comment for benchmark
				#./peakavg.sh -d  "${InputFolder}/$j" -m -x			# peak hours only
				
				./peakavg.sh -d  "${InputFolder}/$j" -m -x -a		# all times
				
			else	

				if [ -z $snapshot ];
				then
					echo "x"
					./dgsh -mv -d "${InputFolder}/$j" 2>/dev/null 
				else			
					echo "y"			
					./dgsh -mv -s -d "${InputFolder}/$j" 2>/dev/null 
					
				fi
						
				# get corrected peaks, peaks and averages as summary - peak hours
				# comment for benchmark 
				#./peakavg.sh -d  "${InputFolder}/$j" -m -v

				# get corrected peaks, peaks and averages as summary - all hours
				./peakavg.sh -d  "${InputFolder}/$j" -m -v -a
				
			fi	
	fi		

	
	if [ ! -z $websys ];
	then
	
		# 3. Find average of top 10 average response times in websys.Monitor

		csvfile=`ls "${InputFolder}/${j}/"*websysMonitor.csv`
	
		ztempname=`basename $csvfile`

		outFolder=${InputFolder}/zwebsysOuttemp
		mkdir ${outFolder}
		
		# sort csv file


		sort -g -r -t, -k4 ${csvfile} >${outFolder}/${foldername}_$ztempname
		
		head -10 ${outFolder}/${foldername}_$ztempname | cut -f4 -d, >${outFolder}/${ztempname}_zzzcsvtemp.txt

		awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }' ${outFolder}/${ztempname}_zzzcsvtemp.txt > ${csvfile}.top10Avg.txt

		printf "${j}," >>"${csvoutfile}"
		awk '{ sum += $1 } END { if (NR > 0) printf "%.4f\n", sum / NR }' ${outFolder}/${ztempname}_zzzcsvtemp.txt >>"${csvoutfile}"

	fi

done
	
#cat "${outfile}"
#cat zzzoutfiles/zzzlist.txt

#cat "${csvoutfile}"




