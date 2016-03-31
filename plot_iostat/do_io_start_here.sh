#!/bin/sh

# What do we want to plot?

mo_sard=""
mo_iostat=""
mo_noSnap="Y"
mo_redhat7="N"

Usage_text="Usage: $0 -d directory [-n (no snap)] [-s -S SAR_disk_list -t sar_start_time_string] [-i -I IOSTAT_disk_list [-l Header line_no]] [-a -I IOSTAT_disk_list] [-[H]PUX sar -S SAR_disk_list]\n\tselect one or more of -d directory_to_work_on -[s]ar, -[i]ostat. -[a]ix_iostat -[H]PUX sar"

# Check command line options

while getopts I:S:t:d:l:siaHnrg o
do	case "$o" in
	I)  MO_IOSTAT_IN="$OPTARG" ;;
	S)  MO_SAR_IN="$OPTARG" ;;
	t)  MO_sarStart="$OPTARG" ;; 
	d)  MO_DIR="$OPTARG" ;;
	s)	mo_sard="Y";;
	i)	mo_iostat="Y";;
	l)  mo_iostatHeadLine="$OPTARG";;
	a)  mo_iostatAIX="Y";;
	r)  mo_iostatRHPwr8="Y";; 
	H)  mo_sarHPUX="Y";;
	n)  mo_noSnap="N";;
	g)  mo_redhat7="Y";;
	[?])	echo $Usage_text
	exit 1;;
	esac
done


# Basic validation

if [ -z $MO_DIR ];
then
	echo $Usage_text
	exit 1
fi
	
if [ ! -d $MO_DIR ];
then
	echo $MO_DIR is not a directory
	echo $Usage_text
	exit 1
fi


# make sure groups of options

if [ ! -z $mo_sardHPUX ] ;
then
	if [ "$MO_SAR_IN" == "" ] ;
	then
		echo $MO_SAR_IN
		echo "You must supply a list of disks in a text file from pButtons sar -d (-p -S SAR_disk_list)"
		exit 1
	fi
fi	 

if [ ! -z $mo_sard ] ;
then
	if [ "$MO_SAR_IN" == "" ] || [ "$MO_sarStart" == "" ] ;
	then
		echo $MO_SAR_IN
		echo "You must supply a list of disks in a text file and start time from pButtons sar -d (-s -S SAR_disk_list -t sar_start_time_string)"
		exit 1
	else
		if [ ! -f $MO_SAR_IN ] ;
		then
			echo "You must supply a list of disks in a text file.(-s -S SAR_disk_list -t sar_start_time_string)"
			exit 1
    	fi 
	fi
fi	 

if [ ! -z $mo_iostat ] || [ ! -z $mo_iostatAIX ] ;
then
	if [ "$MO_IOSTAT_IN" == "" ] ;
	then
		echo "You must supply a list of disks in a text file (-i -I IOSTAT_disk_list) or (-a -I IOSTAT_disk_list)"
		exit 1
	else
		if [ ! -f $MO_IOSTAT_IN ] ;
		then
			echo "You must supply a list of disks in a text file. (-i -I IOSTAT_disk_list) or (-a -I IOSTAT_disk_list)"
			exit 1
    	fi 
	
	fi	
fi	 

if [ ! -z $mo_iostat ] && [ ! -z $mo_iostatAIX ] ;
then
	echo "Hey - you can't be Linux and AIX! Pick -a or -i"
	exit 1
fi
	

# OK extract html to text files

current_dir=`pwd`

echo $current_dir
echo $MO_DIR

cd $MO_DIR

if [ ! -z $mo_sarHPUX ];
then
	sard_filename="sar-d"
	echo $sard_filename
	
	for i in $(ls *html)
	do 
		echo $i
		echo

		for j in `cat "${current_dir}"/$MO_SAR_IN`
			do "${current_dir}"/prepare-sardHPUX.pl ${i} ${j} ${sard_filename}
		done
	done	
fi



if [ ! -z $mo_sard ];
then
	sard_filename="sar-d"
	
	for i in $(ls *html)
	do 
		echo $i
		echo

		for j in `cat "${current_dir}"/$MO_SAR_IN`
			do "${current_dir}"/prepare-sard.pl ${i} ${j} ${sard_filename} $MO_sarStart 
		done
	done	
fi

if [ ! -z $mo_iostat ];
then
	iostat_filename="iostat"
	
	for i in $(ls *html)
	do 
		echo $i
		echo

		if [ "${mo_iostatHeadLine}" == "" ];
		then
			mo_iostatHeadLine=3
		fi
		echo "default iostat header line number = "	${mo_iostatHeadLine}		
		
		echo "Red Hat 7? " ${mo_redhat7}
		
		for j in `cat "${current_dir}"/$MO_IOSTAT_IN`
			do "${current_dir}"/prepare-iostat.pl ${i} ${j} ${iostat_filename} ${mo_iostatHeadLine} ${mo_redhat7}
		done
	done	
fi

if [ ! -z $mo_iostatAIX ];
then
	AIX_filename="AIX_iostat"
	
	for i in $(ls *html)
	do 
		echo $i
		echo
		
		for j in `cat "${current_dir}"/$MO_IOSTAT_IN`
		do 
	
			"${current_dir}"/prepare-iostatAIX.pl ${i} ${j} ${AIX_filename} 
		done
	done	
fi

if [ ! -z $mo_iostatRHPwr8 ];
then
	iostat_filename="iostat"
	
	for i in $(ls *html)
	do 
		echo $i
		echo

		if [ "${mo_iostatHeadLine}" == "" ];
		then
			mo_iostatHeadLine=4
		fi
		echo "default iostat header line number = "	${mo_iostatHeadLine}		
		
		for j in `cat "${current_dir}"/$MO_IOSTAT_IN`
			do "${current_dir}"/prepare-iostatRHPwr8.pl ${i} ${j} ${iostat_filename} ${mo_iostatHeadLine}
		done
	done	
fi


cd "${current_dir}"

# Which of the plots to do?

if [ ! -z $mo_sarHPUX ];
then
	for j in `cat "${current_dir}"/$MO_SAR_IN`
	do
	
		for k in `ls ${MO_DIR}/*${sard_filename}_${j}.csv`
		do
			echo $k
			./do_graph_sardHPUX.sh ${k} ${j} 
		done

	done | tee -a ./$MO_DIR/sard.txt
fi


if [ ! -z $mo_sard ];
then
	for j in `cat "${current_dir}"/$MO_SAR_IN`
	do
	
		for k in `ls ${MO_DIR}/*${sard_filename}_${j}.csv`
		do
			echo $k
			./do_graph_sard.sh ${k} ${j} 
		done

	done | tee -a ./$MO_DIR/sard.txt
fi


if [ ! -z $mo_iostat ];
then

	for j in `cat "${current_dir}"/$MO_IOSTAT_IN`
	do
		for k in `ls ${MO_DIR}/*${iostat_filename}_${j}.csv`
		do
			echo $k
			./do_graph_iostat.sh ${k} ${j} ${mo_noSnap} ${mo_redhat7}  2>/dev/null;
		done
	
	done | tee -a ./$MO_DIR/iostat.txt
fi


if [ ! -z $mo_iostatAIX ];
then
	for j in `cat "${current_dir}"/$MO_IOSTAT_IN`
	do
	
		for k in `ls ${MO_DIR}/*${AIX_filename}_${j}.csv`
		do
			echo $k
			./do_graph_iostatAIX.sh ${k} ${j} ${mo_noSnap}
		done
	
	done | tee -a ./$MO_DIR/iostat.txt
fi


if [ ! -z $mo_iostatRHPwr8 ];
then

	for j in `cat "${current_dir}"/$MO_IOSTAT_IN`
	do
		for k in `ls ${MO_DIR}/*${iostat_filename}_${j}.csv`
		do
			echo $k
			./do_graph_iostatRHPwr8.sh ${k} ${j} ${mo_noSnap}
		done
	
	done | tee -a ./$MO_DIR/iostat.txt
fi






