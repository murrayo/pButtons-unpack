#!/bin/sh

# This script loops through multiple subdirectories to create graphs for windows PERFMON

# Usage:    ./ddescend_S.sh -g -d ../ZCust/201602_SVH/week

# Beware spaces in file path


# 1. Build graphs
# 2. Build csv of peaks and averages
# 3. Find average of top 10 average response times in websys.Monitor

Usage="Usage: $0 [-g] [-s] -d directory ... \n\tselect one or more of -d directory_to_work_on -[g]raphs -[s]napshots"

while getopts d:gasw o
do	case "$o" in
	d)  InputFolder="$OPTARG" ;;
	g)	graphs="Y";;
	s)  snapshot="Y";;	
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
outfile="${InputFolder}/${foldername}_runstats_P.csv"


Looped="N"

# ./dgsh -p -s -w ./perfmon_customer_templates/034_Roche_12Octubre/ -d ../ZCust/201503_Not_Trak/034_Roche/20150726/Customer_Info/12Octubre

for j in ${Filelist}
do

	echo $j
	

	if [ ! -z $graphs ];
	then

		# 1. Build graphs - default no snap shots
		
		if [ -z $snapshot ];
		then
			./dgsh -m -p -d "${InputFolder}/$j" -w "./perfmon_customer_templates/SVJH/" 2>/dev/null 
		else						
			./dgsh -m -p -s -d "${InputFolder}/$j" -w "./perfmon_customer_templates/SVJH/" 2>/dev/null 
		fi
			
	else
	
		if [ -z $snapshot ];
		then
			./dgsh -c -m -p -d "${InputFolder}/$j" -w "./perfmon_customer_templates/SVJH/" 2>/dev/null 
		else						
			./dgsh -c -m -p -s -d "${InputFolder}/$j" -w "./perfmon_customer_templates/SVJH/" 2>/dev/null 
		fi

	fi
		
	echo "Get peaks and averages"
					
						
	# get corrected peaks, peaks and averages as summary - peak hours
	# comment for benchmark 
	./peakavg_P.sh -d  "${InputFolder}/$j" 
		
	# get corrected peaks, peaks and averages as summary - all hours
	./peakavg_P.sh -d  "${InputFolder}/$j" -a
				
done
	
#cat "${outfile}"
#cat zzzoutfiles/zzzlist.txt

#cat "${csvoutfile}"




