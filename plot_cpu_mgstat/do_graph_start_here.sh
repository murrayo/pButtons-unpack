#!/bin/sh

# What do we want to plot?

mgstat=""
perfmon=""
vmstat=""
includeSnap="N"

Usage="Usage: $0 [-m] [-p] [-v|-a [-6]|-b] [-n] [-s] [-c] -d directory ... -[w] windows_perfmon_dir \n\tselect one or more of -d directory_to_work_on -[m]gstat, -[p]erfmon, -[v]mstat -[a]ix_vmstat -[6]aix 6 vmstat -[n]o_time -[s]napshot_graphs -[c]sv_filesonly -[w]indows perfmon template"

# Check command line options

while getopts d:w:mpva6nsc o
do	case "$o" in
	d)  MO_DIR="$OPTARG" ;;
	m)	mgstat="Y";;
	p)	perfmon="Y";;
	v)	vmstat="Y";;
	a)  vmstatAIX="Y";;
	6)  vmstatAIX6="Y";;
	n)  noTime="Y";;
	s)  includeSnap="Y";;
	c)	nograph="Y";;
	w)	WINPDIR="$OPTARG" ;;
	[?])	echo 
	exit 1;;
	esac
done



# Basic validation

if [ -z $MO_DIR ];
then
	echo $Usage
	exit 1
fi
	
if [ ! -d $MO_DIR ];
then
	echo $MO_DIR is not a directory
	echo $Usage
	exit 1
fi

if [ ! -z $WINPDIR ] && [ ! -d $WINPDIR ];
then
	# Example: perfmon_customer_templates/034_Roche_Thai
	echo $WINPDIR is not a valid customer exception directory
	echo $Usage
	exit 1
fi

# make sure groups of options

if [ ! -z $vmstat ] && [ ! -z $vmstatAIX ] ;
then
	echo "Hey - you can't be Linux and AIX! Pick -a or -v"
	exit 1
fi
	


# OK extract html to text files

current_dir=`pwd`

cd $MO_DIR

if [ ! -z $mgstat ] ;
then
	for i in $(ls *html); do "${current_dir}"/prepare-mgstat.pl ${i}; done
fi

if [ ! -z $perfmon ];
then
	
	echo $WINPDIR

	if [ ! -z $WINPDIR ]
	then
		for i in $(ls *html); do "${current_dir}/${WINPDIR}"/prepare-perfmon.pl ${i}; done
	else
		for i in $(ls *html); do "${current_dir}"/prepare-perfmon.pl ${i}; done
	fi
fi


if [ ! -z $vmstat ] || [ ! -z $vmstatAIX ] || [ ! -z $noTime ]  ;
then
	for i in $(ls *html); do "${current_dir}"/exvmstat.pl ${i} ; done
fi

cd "${current_dir}"


# Which of the plots to do?

if [ "$nograph" != "Y" ]
then

	if [ ! -z $mgstat ];
	then
		for i in $(ls $MO_DIR/*mgstat.clean.csv); do ./do_graph_mgst.sh ${i} ${includeSnap} 2>/dev/null; done | tee -a ./$MO_DIR/mgstat.txt
	fi

	if [ ! -z $perfmon ];
	then
		if [ ! -z $WINPDIR ]
		then
			for i in $(ls $MO_DIR/*perfmon.clean.csv); do ."/${WINPDIR}"/do_graph_perfmon.sh ${i} ${includeSnap} 2>/dev/null; done |  tee -a ./$MO_DIR/perfmon.txt
		else
			for i in $(ls $MO_DIR/*perfmon.clean.csv); do ./do_graph_perfmon.sh ${i} ${includeSnap} 2>/dev/null; done | tee -a ./$MO_DIR/perfmon.txt
		fi	
	fi


	if [ ! -z $vmstat ];
	then
		for i in $(ls ${MO_DIR}/*vmstat.csv); do ./do_graph_vmst.sh ${i} ${includeSnap} 2>/dev/null; done | tee -a ./${MO_DIR}/vmstat.txt
	fi 

	if [ ! -z $vmstatAIX ];
	then
	
		AIX_version=7
		if [ ! -z $vmstatAIX6 ];
		then
			AIX_version=6
		fi	

		for i in $(ls ${MO_DIR}/*vmstat.csv); do ./do_graph_vmstAIX.sh ${i} ${includeSnap} ${AIX_version} 2>/dev/null ; done | tee -a ./${MO_DIR}/vmstatAIX.txt
	fi 

	if [ ! -z $noTime ];
	then
		for i in $(ls ${MO_DIR}/*vmstat.csv); do ./do_graph_vmstHPUX.sh ${i} ${includeSnap} 2>/dev/null; done | tee -a ./${MO_DIR}/vmstat.txt
	fi 

fi




